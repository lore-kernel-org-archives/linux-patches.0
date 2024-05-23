Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C940D1D545;
	Thu, 23 May 2024 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470561; cv=none; b=PC7Kdxw/48b777zNdKsNxWVicLGRdDZjuQuf690kREGQVcalBfeYgtPI5gHEDxx5Iz9DL6CRHNDhKaFK0M4SAyWZL/4EhIV0/3UZteeQdZZW+To/SDDC4ROi862spOfMlOi6Y+/SPkW0XuAil+iOqTrtJQetevQvb71Gp0MMWK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470561; c=relaxed/simple;
	bh=JyGcRD1qXDzdztnKIxg597ahw1c+Gtdc14xaMBLrXXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfFOsco3ohMJIAXpA0HioUjgpUFXOX7jte0hUcimYILOthRlRrGRjAAqb010a69vWya3LEv+3+ehvN3P0enxC7yfT0zm4RBNO87EQhAEexfqV5RYY/NDuIoffsHKW1rIpgJq6jR6JC2sTvUwhnWMvVdCLmQ+jfPPgbeMa4Sc/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzVRoD8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzVRoD8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511DBC32781;
	Thu, 23 May 2024 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470561;
	bh=JyGcRD1qXDzdztnKIxg597ahw1c+Gtdc14xaMBLrXXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzVRoD8xBq9glk0MKtbhFg+k9KLGKS7aLFMT3YkJ+knlOf1gqEio4hObX6YyjGqRM
	 rqOA57ds4DmsB6zjZQ8fF95vh1AzvHuQeqguIozL2xqQkCtBIvWixauhA85PpwuvC1
	 JilCZSpuHR6GFk0TR5sE2Rq6y7kD1hIc7JSvEV74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/102] cifs: fix use after free for iface while disabling secondary channels
Date: Thu, 23 May 2024 15:12:35 +0200
Message-ID: <20240523130342.853784193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritvik Budhiraja <rbudhiraja@microsoft.com>

[ Upstream commit a15ccef82d3de9a37dc25898c60a394209368dc8 ]

We were deferencing iface after it has been released. Fix is to
release after all dereference instances have been encountered.

Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311110815.UJaeU3Tt-lkp@intel.com/
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 09bb30610a901..f3d25395d0d3c 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -337,10 +337,10 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 
 		if (iface) {
 			spin_lock(&ses->iface_lock);
-			kref_put(&iface->refcount, release_iface);
 			iface->num_channels--;
 			if (iface->weight_fulfilled)
 				iface->weight_fulfilled--;
+			kref_put(&iface->refcount, release_iface);
 			spin_unlock(&ses->iface_lock);
 		}
 
-- 
2.43.0



