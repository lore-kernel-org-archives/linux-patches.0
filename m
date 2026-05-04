Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD0A3A7F4C;
	Mon,  4 May 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903208; cv=none; b=rp844rhHbTqqn534Wn+md+vTlarDqjIWoGBJZoLg8sAAfClbQIRuKAKMjjmx6fADObZVP8oonNefM5vXKF5P6QeMS0K6cUsL5GGSSXZjR+If+ZwUyHXVCyQv4+FBNGcm5Py51S5YRADA87Z6gBS/5tlNVXoBsOWmjCUt/1RpX0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903208; c=relaxed/simple;
	bh=vt0yyphC9sebOny17y3wxmicBYTenTLqjfliRTZ+aS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBUqpRvTNV6a6BIg0GUBXxmvwIiYJ2Jl1fJbTR5c7+9BI0AIElOw8sjSfTFYBlBfLhKbylJdzy5LH/SkGdyZoz6orCIQSK02OCvql3a5q+fdtuKtUFT443SBM1WBZyiTe3KRB9bq63Pl29WyHmGdShAcn0O8AQQ3muKdchw2DBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AFODEsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AFODEsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CBBC2BCB8;
	Mon,  4 May 2026 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903208;
	bh=vt0yyphC9sebOny17y3wxmicBYTenTLqjfliRTZ+aS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AFODEsbblFkMwvJcVd6T0nCMGXYjsCxIsFKBhPZvhMCPy8sHq9q4LEZyreY/Ud+Q
	 vQCo43RaTh6v8zp8cT1kG3Y90Nlf4ywQ0ielx8yAqEfvB/7OLE98VlQPttsB3hohS4
	 La6risgt5X5FrtFWI2tKp9WAfnKOdM+4QCBauUwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 146/307] netconsole: avoid out-of-bounds access on empty string in trim_newline()
Date: Mon,  4 May 2026 15:50:31 +0200
Message-ID: <20260504135148.271606370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 7079c8c13f2d33992bc846240517d88f4ab07781 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netconsole.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -497,6 +497,8 @@ static void trim_newline(char *s, size_t
 	size_t len;
 
 	len = strnlen(s, maxlen);
+	if (!len)
+		return;
 	if (s[len - 1] == '\n')
 		s[len - 1] = '\0';
 }


