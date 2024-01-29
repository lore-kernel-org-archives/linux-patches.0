Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3B6157E70;
	Mon, 29 Jan 2024 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548042; cv=none; b=HKiKF0yYOHLMQFirtbzvY+lcpWPsKymhWn+X5SuLftkmJXjfEgitBpHIEkBW2IERrLMprZw5mf6RygwmpQ5xK0QZD0Di/NgOpooMQSRWyOPMeFeA/u2X1m2G0oK/xsOKZTgdgDRxe9wgxv/wgBxgM2r7tyEieiv/habA71wFVq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548042; c=relaxed/simple;
	bh=iN/Bj+/EGuiRtmjK/XxQjnRxz7d7qQ6WbHG7sx1jHNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=muX5v4XMmCsnktKXG6VSLVI9nFN/mpvjIrz+AScQ8rP9pg6axMX/RtDojid//dSiK7ZJzFQ9BQElSE6XLDA5ByA9gpAP7TA8+BlRh50QcnX66qVnBk1jHk2sPccNxa2pH6X8jawlmkQZijoHCdTmWSgvcpasEaOTX6ucKCIJHmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdgc+Mp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdgc+Mp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A29AC433C7;
	Mon, 29 Jan 2024 17:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548042;
	bh=iN/Bj+/EGuiRtmjK/XxQjnRxz7d7qQ6WbHG7sx1jHNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdgc+Mp07mXLUlbF+Echr3/N+f5AIg0iDx8EmA/bJ2MfYdyd1TrPVhgnautKPsqgM
	 5hWCrhWLTvUfmNVd8rz1pkUX8NXmerafHey4wyzU7dpFb6i4u5mjNrPCeS/uNzv7co
	 HsxOe0In7pJzay/V3bl8GLKLpBxFee0TGmUlIXm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 042/346] seq_buf: Make DECLARE_SEQ_BUF() usable
Date: Mon, 29 Jan 2024 09:01:13 -0800
Message-ID: <20240129170017.620912193@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

commit 7a8e9cdf9405819105ae7405cd91e482bf574b01 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seq_buf.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
 


