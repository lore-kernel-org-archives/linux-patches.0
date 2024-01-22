Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54F05D73D;
	Tue, 23 Jan 2024 00:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970424; cv=none; b=szCRJV8tyPKR3536OLGgJpKQn+cUcqSGTYxVcIbdHDX8KDr8jzxzSjyXz7tnQpuow0gDWuVcG1b5v73JvlYekqZ4GUAv8tSwyb3rQakS8EuPL4HNS5J/nzIwD5uL5LWjMYZD7oE/mwUvX5CVqRUFn+7BUKf0YK+8vxKibp3Q/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970424; c=relaxed/simple;
	bh=HyZPoUNsBUqvqkLygmi1ofEpWDjZBu5b2OtZ8C4tWuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/QxrWK2Pr+r8gyQC+qjJP1L/Sg7XnxL7GoMTJVyyk9ThoWKTYgSm8LRZE4SnUnd6TK2Os8nmLpLFmehU9SnLBopLmZAiSiad+tgfrmHpgVQn2mAQihSt3kull3UX39bMNjZVp5tIxhhJgAzWptCZe7L/Dx6cX3Zixe9iSwMnDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0sQ/v2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0sQ/v2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4714BC433F1;
	Tue, 23 Jan 2024 00:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970424;
	bh=HyZPoUNsBUqvqkLygmi1ofEpWDjZBu5b2OtZ8C4tWuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0sQ/v2JFTBcTdnNKNq8SbxlLnBJFKB0hs+PApyaWPbxXNVEg+kALpZDP4NmmJLJu
	 m1VLYspABAVorVVODDcc9GR01vi9kqSKoKB5vUM5WHpt7yMc3Px/6h6speTzEKjAf5
	 kDgscPKFIUwbfubUkrXSkR5vv90qH12tMOQMmah4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/417] KEYS: encrypted: Add check for strsep
Date: Mon, 22 Jan 2024 15:53:05 -0800
Message-ID: <20240122235752.126780575@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b4af096b5df5dd131ab796c79cedc7069d8f4882 ]

Add check for strsep() in order to transfer the error.

Fixes: cd3bc044af48 ("KEYS: encrypted: Instantiate key with user-provided decrypted data")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/encrypted-keys/encrypted.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 1e313982af02..fea7e0937150 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -237,6 +237,10 @@ static int datablob_parse(char *datablob, const char **format,
 			break;
 		}
 		*decrypted_data = strsep(&datablob, " \t");
+		if (!*decrypted_data) {
+			pr_info("encrypted_key: decrypted_data is missing\n");
+			break;
+		}
 		ret = 0;
 		break;
 	case Opt_load:
-- 
2.43.0



