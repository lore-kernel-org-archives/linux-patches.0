Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513F418801C;
	Tue, 30 Jul 2024 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358325; cv=none; b=OB8uUhMK+veQ2nyQkHk5eTb7KZ8k7/43eiD/083IZAJb0XYXXF+MT2KpHnXBC/BN9l0kA4ppKwagGcKU2GA9BZdWfIDPCy0AR7GvikkOsVAGLaqWnsNYGcaQ/fLobsYO2TG7jBBSNf5mpfd3AxSQ685VgALcxJVo1DXOtIAYuAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358325; c=relaxed/simple;
	bh=tHoBm7a8RwlwACuPj1lQ5BTfyMkgfLDuVS/ZfE7QL08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Blt9EMAXgIC4imUkZ2Ec48Rx6vUP//pw8FxjpyA4ht2UK4XMeC7N8wOcZvRNrxliD1FkqPH6Z6EcNdRcPms/PRZBYaxpSeuerY+16xaBkJMBzhWKnY044octjO4Xt45RdXbRjcBj7ONPHOU0ipxQO0XuDZ3a9sK1R8Gly7oQE/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC2WvcR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC2WvcR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC64C32782;
	Tue, 30 Jul 2024 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358325;
	bh=tHoBm7a8RwlwACuPj1lQ5BTfyMkgfLDuVS/ZfE7QL08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC2WvcR57gFmSVvtoA0bSZhuPrapxN5kYFQoMqNr13dzaPJETANhi+yclVzEES3Oe
	 ueKWwKjsq4MrIxbtuzt84XTlr7VuHsYnZzC36R2asW2ilNGtIFgbwhXkqeOkXVgcrw
	 W5oBZL/ULUQ/KzR7qKG4cTK0qCkzPm2UCurb40wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/568] fs/ntfs3: Keep runs for $MFT::$ATTR_DATA and $MFT::$ATTR_BITMAP
Date: Tue, 30 Jul 2024 17:47:38 +0200
Message-ID: <20240730151653.587502562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit eb95678ee930d67d79fc83f0a700245ae7230455 ]

We skip the run_truncate_head call also for $MFT::$ATTR_BITMAP.
Otherwise wnd_map()/run_lookup_entry will not find the disk position for the bitmap parts.

Fixes: 0e5b044cbf3a ("fs/ntfs3: Refactoring attr_set_size to restore after errors")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index f8cc49f14c7d3..fc6cea60044ed 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -673,7 +673,8 @@ int attr_set_size(struct ntfs_inode *ni, enum ATTR_TYPE type,
 			goto undo_2;
 		}
 
-		if (!is_mft)
+		/* keep runs for $MFT::$ATTR_DATA and $MFT::$ATTR_BITMAP. */
+		if (ni->mi.rno != MFT_REC_MFT)
 			run_truncate_head(run, evcn + 1);
 
 		svcn = le64_to_cpu(attr->nres.svcn);
-- 
2.43.0



