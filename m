Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0527C3630A5;
	Sat, 12 Sep 2026 08:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203374; cv=none; b=Ij5O80izyE97qVPGuiK4JUDEQqxc7dq/krq/k8wxWXH+5MRCAyvfxO9ntbCGm4XIRO24pJcqlsOSogklddEpHNYxvJ3XjeyTrB9zS0tyXh+6Rbiz/0e86g3uZgQzg2uaEE55DszOm3xALv9howf27oxXRnNkshb/1l2W27lEw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203374; c=relaxed/simple;
	bh=NEUQV+W4Q0HW7S7ZN5tWOUP1wUkBz9k/k9D9/NoovGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtO8EbbG3yUpMmcZwuYI9kIKRxokJ8Rj5cQxH5uopR3eqUltYO7oGb5K2Z0pa0qDcvRL6zqb4tOUTaJMejJd9fH4l5IUhr6cTyT1caqdGa4NjH9bbgz2Wlc2tvdzf7RfgzZBQT/YT8le/kerLlXMto2uSI5N0NVu/d/96aye4HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gv9/oT8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gv9/oT8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EA51F000FF;
	Sat, 12 Sep 2026 08:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203372;
	bh=mLPrY1KeG1mdVo6HQBf+VIZDUlDOo3J3rIU5YuX6/uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gv9/oT8Fhc7BM6YdhDBfBh6wrn/Ayt5M74+O+sEVeuT2tUmJ0QIDReFeZ+qhdOnKf
	 SUdzrqcik/HseizH5CzUWTCCY9WIw+YspRMf36t0N5pS2ROnGrhencxqJtOl9UkQfF
	 NNxZIRj4OG6Gpdv7ohY2GAMJ777QXtj0J3j3UEhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1395/1815] iomap: iomap_bio_read_folio_range_sync is missing a call to bio_uninit
Date: Sat, 12 Sep 2026 08:52:25 +0200
Message-ID: <20260912065721.773040873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit accb6624e383872e7703974a5d5826755fb27032 ]

Which could leak blkg references.

Fixes: c03cea42149d ("iomap: add initial support for writes without buffer heads")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260804124404.737145-3-hch@lst.de
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 30ef78a66b4f0..48100c614431c 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -184,5 +184,6 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 			error = fs_bio_integrity_verify(&bio, sector, len);
 		fs_bio_integrity_free(&bio);
 	}
+	bio_uninit(&bio);
 	return error;
 }
-- 
2.53.0



