Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F2B1E4AB;
	Tue, 23 Jan 2024 01:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972194; cv=none; b=qTN79d97ZPXxNSvneZMHUuWFm10h8QjF4Pc0wcoX4ldo18GtFhBsnnNfxL6Ux/tPsL+0P5Eu/JS5sUGxlbmmtGGM2RP5exGIMNIX8mlUkY+JdqbPd1qbDu2EkFlwj2h6jskw7WLu+K/jFdzLOlKkwvOHRLBVNA4a5+cRmzvYtis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972194; c=relaxed/simple;
	bh=DN3qXsb485XS2jhPitwOZWpV1fjOqkVOQA1lKdm7LD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC5dhw9mzp6A5I8gf7uyzdBOzjhNpb5PHfnedJaF+PzfS5gfGOIQDD7gcqqAP74mByM3unm+f0XEeMPKZAXXXQUSabtP1n4EcvwGY2XP01EzB6yutaGfU/KZT85+0KTOSR0daytx2vbBdrGGGsms6ClMUclOw+jNcR2xY7HaVSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZ4O45o7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ4O45o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A2BC43399;
	Tue, 23 Jan 2024 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972194;
	bh=DN3qXsb485XS2jhPitwOZWpV1fjOqkVOQA1lKdm7LD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ4O45o7RnCl9BpitGx2Oy6kl8l50/UlTK2v29HpGNIADmW4hfohZVy6LaFDm0c2C
	 uuacoinOPTK/1JqB4KBOsYmtfC8Jc2eefyKmPggxrvUVnG2468SxyOfhHVdLMiS8b0
	 h4l2rR2TvnLBlAQSHIIYSn1WHxEzVwmeHPaFiJj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/374] blocklayoutdriver: Fix reference leak of pnfs_device_node
Date: Mon, 22 Jan 2024 15:56:11 -0800
Message-ID: <20240122235748.637648445@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 1530827b90025cdf80c9b0d07a166d045a0a7b81 ]

The error path for blocklayout's device lookup is missing a reference drop
for the case where a lookup finds the device, but the device is marked with
NFS_DEVICEID_UNAVAILABLE.

Fixes: b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index fe860c538747..dc657b12822d 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -599,6 +599,8 @@ bl_find_get_deviceid(struct nfs_server *server,
 		nfs4_delete_deviceid(node->ld, node->nfs_client, id);
 		goto retry;
 	}
+
+	nfs4_put_deviceid_node(node);
 	return ERR_PTR(-ENODEV);
 }
 
-- 
2.43.0



