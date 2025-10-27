Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1851274FD0;
	Mon, 27 Oct 2025 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593143; cv=none; b=GM4rblzCmQCdWf+N04gVsxnJF1KkplD4spszdLUkCQguFc4/cbmY8KzcgoAdm8yuSaUYCpCmJbmbPd6lZA+hIyFBPzEHrV/qYvKg54cPq8qQtz/3AZte63mcH5wzISF2Qvdl5zhq/9zpL0ogl090WmP5ApWLIdRZceawpKxqOOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593143; c=relaxed/simple;
	bh=pFtvzygCfMOCdUq7W5a23sIkJG7GbZfx7HvOq/5w6J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo6drF7WrPLZZQ5MhLSAzw6voaFhYgo0VBqYeTegZCJW3TrQIWg16UhWdeJ0vebziU2uJihRxcvUWZ3Wy9iS/vb7tfoaiaeCrpmk7dixq07/Sis50J1Qya+b1qoGnU/RIuM/x2Eu2c4NGeN5CPEr8d7GHMCiYJQi0iTQZZ+qiBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13JCKVXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13JCKVXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33085C4CEF1;
	Mon, 27 Oct 2025 19:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593143;
	bh=pFtvzygCfMOCdUq7W5a23sIkJG7GbZfx7HvOq/5w6J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13JCKVXkWxCVNDrHLLakrCGt9iBgZHLYCL31Gx6iA7cD6hMQwQ7pKCyExsvGvt01v
	 HbiPou4vG3iELwUbbTL7XS/Zs9dVotcD0w2RKluanJZyJP/pbKsRrK4VpAeKGhOquU
	 GOY/NuCn2ggBoe3jz57Gms/LR/uuOipK0YK1lk+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 003/184] expfs: Fix exportfs_can_encode_fh() for EXPORT_FH_FID
Date: Mon, 27 Oct 2025 19:34:45 +0100
Message-ID: <20251027183515.035091721@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 48b77733d0dbaf8cd0a122712072f92b2d95d894 ]

After commit 5402c4d4d200 ("exportfs: require ->fh_to_parent() to encode
connectable file handles") we will fail to create non-decodable file
handles for filesystems without export operations. Fix it.

Fixes: 5402c4d4d200 ("exportfs: require ->fh_to_parent() to encode connectable file handles")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/exportfs.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index cfb0dd1ea49c7..b80286a73d0a9 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -314,9 +314,6 @@ static inline bool exportfs_can_decode_fh(const struct export_operations *nop)
 static inline bool exportfs_can_encode_fh(const struct export_operations *nop,
 					  int fh_flags)
 {
-	if (!nop)
-		return false;
-
 	/*
 	 * If a non-decodeable file handle was requested, we only need to make
 	 * sure that filesystem did not opt-out of encoding fid.
@@ -324,6 +321,10 @@ static inline bool exportfs_can_encode_fh(const struct export_operations *nop,
 	if (fh_flags & EXPORT_FH_FID)
 		return exportfs_can_encode_fid(nop);
 
+	/* Normal file handles cannot be created without export ops */
+	if (!nop)
+		return false;
+
 	/*
 	 * If a connectable file handle was requested, we need to make sure that
 	 * filesystem can also decode connected file handles.
-- 
2.51.0



