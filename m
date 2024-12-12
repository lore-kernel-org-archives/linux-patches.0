Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C66324036B;
	Thu, 12 Dec 2024 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020353; cv=none; b=u52134jdJWGL+bsb5hu9q09vBbPJiiii7ouyzb7vDXMbQ99Hf6W7czDJqml9hqW2Rz4bty8484QMvcpYlikNsIsXIfD+Ehz16D6hlEuH640zXnYOUrgaVnwSpDtn42dy1x6vDYUl3kaOnqwtq80Tn6N5RlLJeatO66qs5gpY+k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020353; c=relaxed/simple;
	bh=0g29gXdjvGu1ia6J1arjaipSfOAPjG1WZtNlkvK2lYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DmF3kIc0ITPzSpRPATGxmfRMbkGhcW+oI8WSgMDmTr6Ot+H72w/0BgThrb3+fYt4DrS5jOwAeEZ4yAI/rcYZ8K3HuLtRe0zK+W3NUBHYO6WfJ4Q4Vsk9D2pFWuoEXxOWPAzKTD3w2r+AwWN1IUxsxdUznrPBluvqO6s/8ZSUnjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avQy6AEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avQy6AEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06800C4CEE5;
	Thu, 12 Dec 2024 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020352;
	bh=0g29gXdjvGu1ia6J1arjaipSfOAPjG1WZtNlkvK2lYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avQy6AEKXRmIurMEhlKX8/P+qo3GVQdx2gHtMEcmuzIkTR4gChtHad7GPst/BZd3k
	 wsijoJlAf+EDvg/OfTzy/MBprOXmeOFrGhibMMLEpzm0QJ1NVNlLTDTqaVyJt7w3dT
	 ele8/ai3G4bFk2mClBk8zollaXvGwUD2AQU7orhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 445/772] modpost: remove incorrect code in do_eisa_entry()
Date: Thu, 12 Dec 2024 15:56:30 +0100
Message-ID: <20241212144408.311566379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 39e2c8883ddd4..c08beab14a2e0 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -808,10 +808,7 @@ static int do_eisa_entry(const char *filename, void *symval,
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



