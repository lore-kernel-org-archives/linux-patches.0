Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72A26127;
	Tue, 23 Jan 2024 01:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974069; cv=none; b=VTzGJ6JJbsnujnY7booMrr13r/X9PhUersu+qTvPlw28fw5rU2ZH7aRDgRJxzK0so+gqezJCX0ewyyzvYVfJuD04DorrcXGZdji3vy5Bwb0jmr//YQSVTgQGwZJX7X8YmqdZmo4Kne7XUZljGdtFa2iEE0KYdJ0USVSjbf+pl9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974069; c=relaxed/simple;
	bh=+xeTQm+deYW6chccU7qTI7fq4nk1LIdtwjbwcqRU7jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKIK42sSpUVsdZ/7DXGI+1pwj+t8kYACEniTKimG06A06ajaAhQ6unyBISn8myF4nF/E5a9ksA76A5K8D6+hrp/9eXmSo4xY3Y4maAosq8T7g/TjZSwXSnPF0lzGTgEEJcMFiGzrSsxpjrndDghgMJ6LFyHHoUrG35B+BYjC0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOw1f/yY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOw1f/yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C667C433C7;
	Tue, 23 Jan 2024 01:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974069;
	bh=+xeTQm+deYW6chccU7qTI7fq4nk1LIdtwjbwcqRU7jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOw1f/yYEG4n7DE7myEB/Qlo48tEb8Jq/SE2fH6mYM2lEgRJXL6pwUnoJEf7AkPgh
	 lobnrkZmZnw+EqAbk4PP7ZeL7TChHzOF/OohFKExOouZUflXZIFKsHdNX7v3unbvyt
	 Ok9vT54Xd9LcTRUgYGrFKqjN3V6W/jnOTwI2SQK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/583] KEYS: encrypted: Add check for strsep
Date: Mon, 22 Jan 2024 15:51:17 -0800
Message-ID: <20240122235812.995169411@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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



