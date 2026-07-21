Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604D64582E3;
	Tue, 21 Jul 2026 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667738; cv=none; b=ACbsxXkP3CXPZBrhcnn8eS8WuoifFbvyutAaYz80modQjhL/+KP4NOZSVm/D0AHtmd9okP4E8aqiCTbs7KscmITv0XrsCzScGd5oNS0mwRwlvsUmvFoXMAFHrPAT0u2O+3t8/Qm+E4e+dFsmJwkv1oRE6CakUunIR9JwVJ0X1cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667738; c=relaxed/simple;
	bh=tz9EHsW7suWO4W4RGZc/ip1bskTPJ+JodViFH0wgMuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhiDBirjD9XF0PXA/AaHGf9+ZdggpGGjFtRS1AZuj4mVoXyapqK5bz124lOgtXmxbn5OqbxW81gjtFIa8kevzEhSVtsF1EcYJTrOTjG/Y1SpLP5PSiS254LxjBHtr6Jqi13f4bpmETDtQKDKdfKJo0rBNw3JPIMqZ/CWtA8+GSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PniZQmca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PniZQmca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4091D1F000E9;
	Tue, 21 Jul 2026 21:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667731;
	bh=2SCcCkA/4CaVHf2bTMVaXNz4pibwnIqg/ccoWZgiuiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PniZQmcafFbJ+VW0w1qrXX3wMjYKJZsDokqTUMoY6ZRaHkoZ3OWfHcPePo/HJCPWx
	 585fj4dqJG/7sR/D6/8LkEVeUeCIdL3yF0zzgPmKRPsVB6wnVWwFfzmMOCRP3xYKvj
	 3OkVy8UrwLCAYQgFqw+J8aNE2gWHd4i+DUxci2xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Richter <Simon.Richter@hogyros.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1172/1266] PCI: Prevent resource tree corruption when BAR resize fails
Date: Tue, 21 Jul 2026 17:26:49 +0200
Message-ID: <20260721152508.011132934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 91c4c89db41499eea1b29c56655f79c3bae66e93 ]

pbus_reassign_bridge_resources() saves bridge windows into the saved
list before attempting to adjust resource assignments to perform a BAR
resize operation. If resource adjustments cannot be completed fully,
rollback is attempted by restoring the resource from the saved list.

The rollback, however, does not check whether the resources it restores were
assigned by the partial resize attempt. If restore changes addresses of the
resource, it can result in corrupting the resource tree.

An example of a corrupted resource tree with overlapping addresses:

  6200000000000-6203fbfffffff : pciex@620c3c0000000
    6200000000000-6203fbff0ffff : PCI Bus 0030:01
      6200020000000-62000207fffff : 0030:01:00.0
      6200000000000-6203fbff0ffff : PCI Bus 0030:02

A resource that are assigned into the resource tree must remain
unchanged. Thus, release such a resource before attempting to restore
and claim it back.

For simplicity, always do the release and claim back for the resource
even in the cases where it is restored to the same address range.

Note: this fix may "break" some cases where devices "worked" because
the resource tree corruption allowed address space double counting to
fit more resource than what can now be assigned without double
counting. The upcoming changes to BAR resizing should address those
scenarios (to the extent possible).

Fixes: 8bb705e3e79d ("PCI: Add pci_resize_resource() for resizing BARs")
Reported-by: Simon Richter <Simon.Richter@hogyros.de>
Link: https://lore.kernel.org/linux-pci/67840a16-99b4-4d8c-9b5c-4721ab0970a2@hogyros.de/
Reported-by: Alex Bennée <alex.bennee@linaro.org>
Link: https://lore.kernel.org/linux-pci/874irqop6b.fsf@draig.linaro.org/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-2-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2312,6 +2312,11 @@ cleanup:
 		bridge = dev_res->dev;
 		i = res - bridge->resource;
 
+		if (res->parent) {
+			release_child_resources(res);
+			pci_release_resource(bridge, i);
+		}
+
 		res->start = dev_res->start;
 		res->end = dev_res->end;
 		res->flags = dev_res->flags;


