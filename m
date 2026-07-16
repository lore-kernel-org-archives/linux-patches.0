Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AB8432E9D;
	Thu, 16 Jul 2026 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212064; cv=none; b=TKt3THECMIXWnaujKjqpHoieIVZ077fkZr4H/AKbuOgq+8NNIIy37kONHtZEplNKF4L9DcXFH7pjm0m7Q7YqbOY0/vuT13IcnsZpvDt96Qy66J1qd0Nv+J8x8axNe3HSdRDFH5yXtxI42NIwePwa+bylU9f2y81V/SgjLIPPUr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212064; c=relaxed/simple;
	bh=vlWbUyYr/5Ouum+us5HZcCo8lCzglcNuT1MJVewcgY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md+X3UVVOfPzXjIPHMnMEWAQSY5P5FzFYzUUGVPr42wcG1CxcWAXLpxzjb4PMW8acb1ONkUqmhT20izIKJsSAovTiCgFTCx2thDhAfcwt15FFUJteLW88x4J/nvtyDRrluqEj3UgbII3Rx5CHbuJZwX3Kg1Xrq+fLJzH0HwJghk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiRBprrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiRBprrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCFE1F00A3F;
	Thu, 16 Jul 2026 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212063;
	bh=sHzOmzU8S6U33DAF0Qk40Esrv1Mq9Nc4UkoLSeBWNzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jiRBprrf4RMXBbk85F/vDm8oQ9kxxsvHCQJKoKGmSv++n6TcOvs5RSrMB1sLHsbnR
	 TeDY3dlVfQcBNb9LLEvfwiIMPwjU4MPzP5ZoZvuRdtEVgw40mnWvw1h5+c3/ZvVjvP
	 xa8YDQ5rE9717C9JPtiCdt7I4EliPyL3B0vLejlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 183/349] smb: client: harden POSIX SID length parsing
Date: Thu, 16 Jul 2026 15:31:57 +0200
Message-ID: <20260716133037.477382434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit 7ad2bcf2441430bb2e918fb3ef9a90d775a6e422 upstream.

posix_info_sid_size() reads sid[1] to obtain the subauthority count,
but its existing boundary check still accepts buffers with only one
remaining byte. Require two bytes before reading sid[1] so all client
paths that reuse the helper reject truncated POSIX SIDs safely.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5221,7 +5221,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


