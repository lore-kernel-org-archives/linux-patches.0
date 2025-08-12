Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4572E285E;
	Tue, 12 Aug 2025 18:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022425; cv=none; b=nlX6TupsR0H3EF49WdYWJCmhoMFtWjsvw1S1o6ASfemryDOAz0WF07o7+2hClTXwwX8XDbOstrlsAvPbwpxZwjHWf+SdC8P6uZXypQ+5cTirMlphwJnwhanKiCiI6THNuvMcjCdxl/sFOMzUhXnRJeNLyw0jNU6ALBcGphhidfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022425; c=relaxed/simple;
	bh=kT6iuwzzeIoNjsuktMt75ZdAAZlEvBv2pJo/rJT3IvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9mbBDh1wLAjPpbl5NFsV0mcftWbOaUESfsckG8/uSx0eZtfK5kBu0Vjpi5Isccgy7XAVrKJep6w5IeRE/6LDVtheBWP3jknNb1R9q731NJcMONoUXQw0DT289PuuLaG++Nl9j3SoreXqxgc8zR/FRwKZ1J1FCrVUIYhLDUgVPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI575v/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI575v/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD68C4CEF1;
	Tue, 12 Aug 2025 18:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022425;
	bh=kT6iuwzzeIoNjsuktMt75ZdAAZlEvBv2pJo/rJT3IvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wI575v/xwSCBPI3ua8/l64veb8hXyjV29MYYEO8L9oI40QT5q3ZxRFbSFy8X/9ykk
	 qU41q1wmhoHB3FbpMqgXXPFU7sb7oFDeniovcHPgd9T4u6DB/0JyT0FLM84Bj1+aXE
	 Fw5vq+MR6wccIyR5yYkn7hf19+H8NHT+EGI5AVRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/369] fortify: Fix incorrect reporting of read buffer size
Date: Tue, 12 Aug 2025 19:27:29 +0200
Message-ID: <20250812173020.497353708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 94fd44648dae2a5b6149a41faa0b07928c3e1963 ]

When FORTIFY_SOURCE reports about a run-time buffer overread, the wrong
buffer size was being shown in the error message. (The bounds checking
was correct.)

Fixes: 3d965b33e40d ("fortify: Improve buffer overflow reporting")
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20250729231817.work.023-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 0d99bf11d260..71f9dcf56128 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -596,7 +596,7 @@ __FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
 	if (p_size != SIZE_MAX && p_size < size)
 		fortify_panic(func, FORTIFY_WRITE, p_size, size, true);
 	else if (q_size != SIZE_MAX && q_size < size)
-		fortify_panic(func, FORTIFY_READ, p_size, size, true);
+		fortify_panic(func, FORTIFY_READ, q_size, size, true);
 
 	/*
 	 * Warn when writing beyond destination field size.
-- 
2.39.5



