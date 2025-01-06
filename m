Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E377603F;
	Mon,  6 Jan 2025 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177623; cv=none; b=cYk2SS7CBPJ3/Ul1+pF/Fei2mmSi1nDQbRFBM1vpRNWZ7RQXskVkIoHKvVRdARVaJA6Nzivvz4fCYRSRyD4+PXVKC0akEpQ4MDp+68C4gn3bRIkN8LUGR4aofPc07qls15+01WHBW0vtZzxGc0jOgVCEphmSoh6si7/kvZuzKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177623; c=relaxed/simple;
	bh=WNFPotg1tlDDPRdjMe3Qy/fbEp6uRlAZyZ64oS3oJGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tl3GuzhrctyqHQfkNQkRTK92LR4uuvcpEc9czuUtjgXVjfcKuLTDGFxjG6cz32WY/aQiXCVYJWROMKqAjYIvvPqk02vimF1rDB9erGqtKwd0h140EYCYDD/Ei69Ybq58U2h1kysjbYsdrObfV8dInZgpf4T41oP612O9dadtiqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srUwYJqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srUwYJqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A9DC4CED2;
	Mon,  6 Jan 2025 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177623;
	bh=WNFPotg1tlDDPRdjMe3Qy/fbEp6uRlAZyZ64oS3oJGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srUwYJqUnIuMrLCDjJXSvFSrOAVlid5DEMnIY9nRkvyW+/47U5cPLj+10QjbUHdiK
	 9JmBTDS7uusEwPKAcWGVt1i20zjpaiWsU6+7khJzkNRFYUmlpixg3QiQwXGS0MuCOm
	 C8G6Z+ZHMuTuORJ2TUVWdFgcxbqGxa89Glf8XtZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/222] seq_buf: Make DECLARE_SEQ_BUF() usable
Date: Mon,  6 Jan 2025 16:16:38 +0100
Message-ID: <20250106151158.105354644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 7a8e9cdf9405819105ae7405cd91e482bf574b01 ]

Using the address operator on the array doesn't work:

./include/linux/seq_buf.h:27:27: error: initialization of ‘char *’
  from incompatible pointer type ‘char (*)[128]’
  [-Werror=incompatible-pointer-types]
   27 |                 .buffer = &__ ## NAME ## _buffer,       \
      |                           ^

Apart from fixing that, we can improve DECLARE_SEQ_BUF() by using a
compound literal to define the buffer array without attaching a name
to it. This makes the macro a single statement, allowing constructs
such as:

  static DECLARE_SEQ_BUF(my_seq_buf, MYSB_SIZE);

to work as intended.

Link: https://lkml.kernel.org/r/20240116-declare-seq-buf-fix-v1-1-915db4692f32@linux.ibm.com

Cc: stable@vger.kernel.org
Acked-by: Kees Cook <keescook@chromium.org>
Fixes: dcc4e5728eea ("seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index d9db59f420a4..468d8c5eef4a 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -22,9 +22,8 @@ struct seq_buf {
 };
 
 #define DECLARE_SEQ_BUF(NAME, SIZE)			\
-	char __ ## NAME ## _buffer[SIZE] = "";		\
 	struct seq_buf NAME = {				\
-		.buffer = &__ ## NAME ## _buffer,	\
+		.buffer = (char[SIZE]) { 0 },		\
 		.size = SIZE,				\
 	}
 
-- 
2.39.5



