Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCA3222D4E;
	Thu, 12 Dec 2024 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024460; cv=none; b=AwfOCKItG1xwV5dTkq+ngVv+46qWdcxanqoy4rtiWix5zRLOP3sq88OyZtQGGfDNrzSK/spWKXckuQJ/1kDdkCu4RuTHaj0Wxp3f/bhLG+pOwBExqccKXP/G5Fjhsp45ZaCkJJVDdH0y3iwBCftLeNQgvVokjCEO14uTteHGd48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024460; c=relaxed/simple;
	bh=rmbDZVV8bbZP9VpKEogTRl6tPRIZckccCEbybGBo0kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lN4AkIXf+NGMprBX3J6//WhkLOC1Ba63aiQyhS7N7iT9w9ny4EjUCQ6ixIVV8TYXyXU8rmJvslcyjjC0Hgk+nubjluUXBBQZeqTZGg6bTHZt6VVlIhLEg0Ofae/ajmstMLfrowSD+Q8PzOWMxYau8U2bBGFP5vLp67Cb8fuvkGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Td1aTrdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Td1aTrdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C45C4CED3;
	Thu, 12 Dec 2024 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024460;
	bh=rmbDZVV8bbZP9VpKEogTRl6tPRIZckccCEbybGBo0kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Td1aTrdZIBMGSwVraQfM9RQB6p5YTgD+qcxGrNoZbGtOurZtmwf2/I02nr69HuDd1
	 dHdACv/50bcE56Whx3Z7PryynleIylA7BaAH1oLDdQzEr8klvQPMx0cP0sTttuEPLT
	 NuaXaGC24IRrO3h4AbLz73gxy3khRBXTWSX5MSmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/459] modpost: remove incorrect code in do_eisa_entry()
Date: Thu, 12 Dec 2024 16:00:41 +0100
Message-ID: <20241212144305.616510802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7154df094f40b..1c9c33f491e64 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -786,10 +786,7 @@ static int do_eisa_entry(const char *filename, void *symval,
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



