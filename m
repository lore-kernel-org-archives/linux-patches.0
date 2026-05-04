Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919EC3DE452;
	Mon,  4 May 2026 14:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904573; cv=none; b=kkkGjsMtnEBOuquCXPlRZV2OnT01GBCKVwrjHdIBzJte3gA7TVC+vHYotE1zeO0nr1DXKfNiqoE99qXff1j4Q9qQUDRXxzER9GyUiFLhApqeQ1AxNt8FMuHuz/17Sumqc9oeILqv3YsfzPXFAdDDR51504kC08vOPDDmtJu2PTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904573; c=relaxed/simple;
	bh=ARgNfsh9ZubnvRKN9sTq4Srpxf27F3I3ak5vMeDIZNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mlg2GJn6CGykRhXLsY4XQhUJZ3//y40/t4NamOv8eQfSV7DEPq3tgBGX0+KvZd/HvWbrHuhpBLUydLo3p4RtgramSU/cxXUE/ICCIz/ItUESDEXIKo/6GpWss+XmPUGQrWro3gfDEm9XFqxxPI4M1I0mNsiyocyOsacO2HxDYDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxSRZzev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxSRZzev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275ECC2BCB8;
	Mon,  4 May 2026 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904573;
	bh=ARgNfsh9ZubnvRKN9sTq4Srpxf27F3I3ak5vMeDIZNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxSRZzevRzESS6S7/jxEL7DwCCDlHzDdRlxCmFNJwL2Q2lZReizKigKyYhn+4hQzK
	 e3rUE2CoHcT8/JMiEpStSoZ3vNRQlbxpcbCllahYitYLPa3HJAVzfRmRE/Ib+DDQg3
	 PLGr0rvWZ5uRlpC5aLGbtEy38vtDIzklB6AUtE4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 091/215] netconsole: avoid out-of-bounds access on empty string in trim_newline()
Date: Mon,  4 May 2026 15:51:50 +0200
Message-ID: <20260504135133.482572240@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -300,6 +300,8 @@ static void trim_newline(char *s, size_t
 	size_t len;
 
 	len = strnlen(s, maxlen);
+	if (!len)
+		return;
 	if (s[len - 1] == '\n')
 		s[len - 1] = '\0';
 }


