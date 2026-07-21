Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB20470452;
	Tue, 21 Jul 2026 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659662; cv=none; b=FhtHBUMYcvMo8iWMDRhO5uSndZIu9H+y63tC8cdS3uYrwb5Znq8L42QHLGa5d5l7FwKvV6eLazC1XbexgBsy3jvIXsT3l7THyGz/GVY4/UITKcaFwV+urB4zcqP/6uow2dbEHiH0rVN1aoULl4M8qhZ5PSJJaToI4s0bEzGv/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659662; c=relaxed/simple;
	bh=fFxntf66JjP6OwB0lYt64XDDxqyLBQ40ULRF76hEocU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ApbAue0JleFO/8sf3S8MHflIRFdZxiQkpLSxBhPqsiRyqlTlbbJQyTGNuqJFucB4YcFgOYNJ1DI1cE/WvYOAGk5Skf51GVzYQ9w8hMMbhnbhZNAIjiGTlYH+WEUOix6yMWadDrXkU9N6snCGkE/tDqExUKC8HtqfCSb5S2is6Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYB/71Eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYB/71Eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7391F000E9;
	Tue, 21 Jul 2026 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659661;
	bh=lwPTsoMPZmET1NwHU0fSlpIHsW6PeGLlU09KJwVS9Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYB/71EhOjU6rQ9w/rPmjaLDDKNO/jwHASoKoaRf8vA8v1yQjBMlT2PD2lxw9/sX2
	 TCIVdh8iuEK1y3yUmT82BukJ1RJVvI4UEgiiHEr00LEd+Ycv5pSQbE2Rbxqi7QWULe
	 VhqQzw8p3i+H5a10P4HUTpF4V6s5S0biDgh7rZMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 1604/1611] PCI: Fix BAR resize rollback path overwriting ret
Date: Tue, 21 Jul 2026 17:28:40 +0200
Message-ID: <20260721152551.553782277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 08d9eae76b85263173f8c833800e3cc409ee1be4 upstream.

The commit 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback
path") added BAR rollback to pci_do_resource_release_and_resize() in case
of resize failure.

On the rollback, pci_claim_resource() is called, which can fail and the
code is prepared for that possibility. pci_claim_resource()'s return value,
however, overwrites the original value of ret so
pci_do_resource_release_and_resize() will return an incorrect value in the
end (as pci_claim_resource() normally succeeds, in practice ret will be 0).

Fix the issue by directly calling pci_claim_resource() inside the if ().

Fixes: 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/linux-pci/aW_w1oFQCzUxGYtu@intel.com/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260121131417.9582-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2504,8 +2504,7 @@ restore:
 
 		restore_dev_resource(dev_res);
 
-		ret = pci_claim_resource(dev, i);
-		if (ret)
+		if (pci_claim_resource(dev, i))
 			continue;
 
 		if (i < PCI_BRIDGE_RESOURCES) {


