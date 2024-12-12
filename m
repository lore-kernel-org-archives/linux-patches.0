Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990D1487CD;
	Thu, 12 Dec 2024 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022921; cv=none; b=qAdgEKJV8vdxXSfMRmdrJC07YvwSVVfq2c6izYbb4qjmiKryyRqrAHeRPWmNDj5N72aJyr1m/i+F3ScvdjccNGi6clctxzelZn/yBf3xlkzspRSIGUWml2SWs55MhZw8NDq1WLlkyWDMCqd6HriElKtGZMzRcqcshRZJgcU2iZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022921; c=relaxed/simple;
	bh=M/WWFCm3Yt8l5D+9TnYxz2ruDIQ/Zk9vD9uQNW/PuSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+0X20GWeuzdDTKNbfugidmY0UxgMosdgfUVtM51cfFZl4evYV64JIlCiWSCEZNKy39CYENvZdiB2q+8hBXV2pJIxuTx4yHATOGmN2mUPoMOGc9PpFAheKw4uZe6jB6w9GyYtP4Twd4ky3TpsttuaWE1mwLD23f4A8wfayAooJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLWLuNUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLWLuNUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876C6C4CECE;
	Thu, 12 Dec 2024 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022921;
	bh=M/WWFCm3Yt8l5D+9TnYxz2ruDIQ/Zk9vD9uQNW/PuSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLWLuNUVuiLxj02vVd5Ed9t+1wDii+ZSqItYFSh1EsL32npsTfyC+nM7zqCG7q86J
	 eWZ7AonvE4ft84d6U1Ew0pdGKnv679gNW/AiLkSO/MnYLCbhxw2noAR3mJRRtId2fX
	 tj3wp11rcbqPpv76ybgZm429P8bJuggtpEuiEQGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 369/565] modpost: remove incorrect code in do_eisa_entry()
Date: Thu, 12 Dec 2024 15:59:24 +0100
Message-ID: <20241212144326.211332169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 0c3e091319e4748cb36ac9a50848903dc6f54054 ]

This function contains multiple bugs after the following commits:

 - ac551828993e ("modpost: i2c aliases need no trailing wildcard")
 - 6543becf26ff ("mod/file2alias: make modalias generation safe for cross compiling")

Commit ac551828993e inserted the following code to do_eisa_entry():

    else
            strcat(alias, "*");

This is incorrect because 'alias' is uninitialized. If it is not
NULL-terminated, strcat() could cause a buffer overrun.

Even if 'alias' happens to be zero-filled, it would output:

    MODULE_ALIAS("*");

This would match anything. As a result, the module could be loaded by
any unrelated uevent from an unrelated subsystem.

Commit ac551828993e introduced another bug.            

Prior to that commit, the conditional check was:

    if (eisa->sig[0])

This checked if the first character of eisa_device_id::sig was not '\0'.

However, commit ac551828993e changed it as follows:

    if (sig[0])

sig[0] is NOT the first character of the eisa_device_id::sig. The
type of 'sig' is 'char (*)[8]', meaning that the type of 'sig[0]' is
'char [8]' instead of 'char'. 'sig[0]' and 'symval' refer to the same
address, which never becomes NULL.

The correct conversion would have been:

    if ((*sig)[0])

However, this if-conditional was meaningless because the earlier change
in commit ac551828993e was incorrect.

This commit removes the entire incorrect code, which should never have
been executed.

Fixes: ac551828993e ("modpost: i2c aliases need no trailing wildcard")
Fixes: 6543becf26ff ("mod/file2alias: make modalias generation safe for cross compiling")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 23e7102abe0cd..d911485646c5c 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -799,10 +799,7 @@ static int do_eisa_entry(const char *filename, void *symval,
 		char *alias)
 {
 	DEF_FIELD_ADDR(symval, eisa_device_id, sig);
-	if (sig[0])
-		sprintf(alias, EISA_DEVICE_MODALIAS_FMT "*", *sig);
-	else
-		strcat(alias, "*");
+	sprintf(alias, EISA_DEVICE_MODALIAS_FMT "*", *sig);
 	return 1;
 }
 
-- 
2.43.0



