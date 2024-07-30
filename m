Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A8A1A76B7;
	Tue, 30 Jul 2024 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359667; cv=none; b=YNq5eo2MzHTj4Xk9Yb3WA10o8LlMoKn7kO+9SO9jFk0s+fPW8Sh/DjUgpIRt5cm8VWgDFN89JuOC//jESGEMqG9EzjEmJtXBVConlosLNBJjkZLJirs0YE82+BpMfC5jc635JBO85FreGwmWEArfF8l0T5XOYsH3mJRSMzHiwXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359667; c=relaxed/simple;
	bh=JsaMrhDv9gJNY40F4Utd6g1evt19jfTkmDvM0L5M8s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQQoZd1x+YqfqT+U7i5XJYWhlHAIGhiA8eWpGWn1cGInRaGI7ctszllvPxN6vzHAF++YoFeNXVCI/fj/lxgIhV9antp4XbnX5jSOrABfXnZDe3sPTgD1FLXENBhRTuFmMVloBfhWhTwG519AQmlcr7NhzH5NXrTn0Ll4q1x0VfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyTfxA8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyTfxA8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79CDC32782;
	Tue, 30 Jul 2024 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359667;
	bh=JsaMrhDv9gJNY40F4Utd6g1evt19jfTkmDvM0L5M8s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyTfxA8acq5TCg+Tswk7Vy7rJRlznQ/DB1QCrdkd7IAtP6BGsS5IuDmdY66qS/HBG
	 C9OUaPuzdkAHSd15/GzYrjpoWoAvXnZQmDNE9pAG846vHgRC9Zs62s2eyVhrHHC7MU
	 eoec4EAjBySS/HzMo2XDvf2JxOizX8hvI4Mxxnvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 516/809] fs/ntfs3: Keep runs for $MFT::$ATTR_DATA and $MFT::$ATTR_BITMAP
Date: Tue, 30 Jul 2024 17:46:32 +0200
Message-ID: <20240730151745.119113721@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d13da5523b1a..a810ef547501d 100644
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



