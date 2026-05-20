Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A192A3F20E5;
	Wed, 20 May 2026 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297371; cv=none; b=QTHKZJbiqfANTojrcD+x/O6Z8t8ND1tLSI5mOQFadvbP4yfcHHOW86dAhBclC5gXFJoq2k6WvijKWa24Jh51CXo1+tX2ubqLubu4jjrVObcNgkdXP9Cgpv9PcTCeV8LEUSKYv2ldI5k3HbscthbohsLGGFnHdNoX7Uox/lUpSYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297371; c=relaxed/simple;
	bh=VZMxkuJ0lzsWfoc0bUAP2Hd6stIwrI7HZ9Ay/iUpo88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6phCiSSuljYmAH804bcZMZcnNjBdy1ooPtVJBoAopZopgKQ2vmSyv5QPlpYJddkt9aP8w5gcMYUem3jovTQW5sS3DmqeD/nQt0DeMaKIwC4NFfze91ZXPoWmxO33JdGjcc7gC2P/+u2IDDFbvus0JSvkXUrSHYyzgP9ThA6yRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr0wJLjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr0wJLjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1891F000E9;
	Wed, 20 May 2026 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297370;
	bh=D07j4y4bmzYApxlb+nbmb3GNISkreBaupMezSz9jqfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cr0wJLjdjrD9rj4T6LihlzrVTaqbxN1Ddh2C79oj1sIpeKPkdcw3v5f74Fcy1u3Ri
	 hZY8Jjf2KFSOKVXRmuBIhsDMjfti8eeiNWgAUWHQW4nxAjnmx+VJA/Bifc9f/R5bBZ
	 8uemVkmkbL1hJ/g6m9RYy2gUiVZF1w3hEw4e6Ryw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 1141/1146] arm_mpam: Check whether the config array is allocated before destroying it
Date: Wed, 20 May 2026 18:23:11 +0200
Message-ID: <20260520162214.075932725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit 6ccbb613b42a1f1ba7bfd547a148f644a902a25c upstream.

__destroy_component_cfg() is called to free the configuration array.
It uses the embedded 'garbage' structure, which means the array has
to be allocated.

If __destroy_component_cfg() is called from mpam_disable() before the
configuration was ever allocated, then a NULL pointer is dereferenced.

Check for this case and return early if the configuration is not
allocated.

__destroy_component_cfg() also frees the mbwu_state as this is allocated
by __allocate_component_cfg(). As the mbwu_state is allocated after
comp->cfg is set, and is also under mpam_list_lock, only the first
pointer needs checking.

Fixes: 3bd04fe7d807 ("arm_mpam: Extend reset logic to allow devices to be reset any time")
Cc: <stable@vger.kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/resctrl/mpam_devices.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2359,6 +2359,9 @@ static void __destroy_component_cfg(stru
 
 	lockdep_assert_held(&mpam_list_lock);
 
+	if (!comp->cfg)
+		return;
+
 	add_to_garbage(comp->cfg);
 	list_for_each_entry(vmsc, &comp->vmsc, comp_list) {
 		msc = vmsc->msc;


