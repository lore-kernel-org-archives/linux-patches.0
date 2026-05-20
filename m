Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AC14028CB;
	Wed, 20 May 2026 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302916; cv=none; b=AULa6iaD5SVBd68UwbCQjspEs7BBpVD8ARIvq352mGrbk7BCFbK4dEJWWvy+jyL/geQcjZpR/uYUxJN1ea16VkpfX/RY83GSGTo5Q4nHGaZ9APdfK9Ksq3FmIV3PX4I0Lu1V5XGYSG/B5iAcLgQ9kjtXkkRkXO1GB6HM3NN0MAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302916; c=relaxed/simple;
	bh=x0/BCerZvb+srI3O6BmnKYIXSz4I2E9rw2Gbpvsl3+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VddHRrwEn/F1ETkTXOxFT+5ElXqVjuyTvcBlXiL3RggD3PRcZ3vDuGPz0GWbg9K+gjbjdpnAa+LohX40k8Iapu+Vpw0xqsSxbkFblfq4mTjkoRXisbV2Iw9CbFWPs60aydWRmqNtOlO7UHidTVgWCDolfdASxmgJz8895/b4iKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgkKzOXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgkKzOXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4A41F00893;
	Wed, 20 May 2026 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302914;
	bh=D8tevLGrTjGvkYpHnnmh0qa73c+CqwU/O79J0blw2FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgkKzOXhMr082/aLdOXIs05btmZxEGJvIsydPt9jgZmULVI7qA3+b3CMr5v6sHw/y
	 TRSsNgeVIscFYyFSICjzlX5MsXnys/vLxv+dJk1zgGJWJL3mQzvUR6kyf97AeMzhiT
	 ILT9VCELc7ATVyFnHpxBezhIgjNDcTKvcw1g8VT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 449/508] netconsole: avoid out-of-bounds access on empty string in trim_newline()
Date: Wed, 20 May 2026 18:24:32 +0200
Message-ID: <20260520162108.325310282@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 7079c8c13f2d33992bc846240517d88f4ab07781 ]

trim_newline() unconditionally dereferences s[len - 1] after computing
len = strnlen(s, maxlen). When the string is empty, len is 0 and the
expression underflows to s[(size_t)-1], reading (and potentially
writing) one byte before the buffer.

The two callers feed trim_newline() with the result of strscpy() from
configfs store callbacks (dev_name_store, userdatum_value_store).
configfs guarantees count >= 1 reaches the callback, but the byte
itself can be NUL: a userspace write(fd, "\0", 1) leaves the
destination empty after strscpy() and triggers the underflow. The OOB
write only fires if the adjacent byte happens to be '\n', so this is
not a security issue, but the access is undefined behaviour either way.

This pattern is commonly flagged by LLM-based code reviewers. While it
is not a security fix, the underlying access is undefined behaviour and
the change is small and self-contained, so it is a reasonable candidate
for the stable trees.

Guard the dereference on a non-zero length.

Fixes: ae001dc67907 ("net: netconsole: move newline trimming to function")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Gustavo Luiz Duarte <gustavold@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260420-netcons_trim_newline-v1-1-dc35889aeedf@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index f58643bdafc5c..fffffa3658d22 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -278,6 +278,8 @@ static void trim_newline(char *s, size_t maxlen)
 	size_t len;
 
 	len = strnlen(s, maxlen);
+	if (!len)
+		return;
 	if (s[len - 1] == '\n')
 		s[len - 1] = '\0';
 }
-- 
2.53.0



