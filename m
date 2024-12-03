Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A2D1EF08A;
	Tue,  3 Dec 2024 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236884; cv=none; b=O2JMyoIOqxb7hgfixHh3euxoy7QBOs8cD2UpvoV1ZTes1v7BEA60mxgKziR0rjIJRP2Qiyjmf3FQDZ7eLusScvDfTw5Fnu4KKkQZgsU2Chuk0ufc6/slEOTc16rP4vjS6qXXCvrO+yM3UP+PU7oy2XEZ6T5GRlZ2QcGJa5KtYaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236884; c=relaxed/simple;
	bh=uJb3tNZ1HKrLBL2ZN7hd5tr6ttBvacPjVRpwHwNj/pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7sT3Rx8xJCzyif5GUDXxrhRb9OFJF4SDX1tccxrPnrwB6sXIJNuZkm43HudTepeVZmNAvAJUpcv28v+edpHzb9Iq/P8RqPc1ppDhO76VAJEPIH3v7yUOG0KrV4A3KmyiiY40CCEvA22wuEfrAhgRs0Yhdo/g46mZml/h1f20ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKCCZQyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKCCZQyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4A5C4CECF;
	Tue,  3 Dec 2024 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236883;
	bh=uJb3tNZ1HKrLBL2ZN7hd5tr6ttBvacPjVRpwHwNj/pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKCCZQyzA0gWeRTtXmqztWD2Yck3hvzwYyLFa7yr21BekIZBgDuGklqI1Z7Lizfm0
	 wCHOKucSY5oQPQRPbEFy4N3XCN72GWgdmcuWW08FxZdSq3hXq85cBqWq6dFac3Z4bb
	 nH79sfYj83drU1uQLwaxPxkFcDfhYG0TJzUyusgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/138] modpost: remove incorrect code in do_eisa_entry()
Date: Tue,  3 Dec 2024 15:32:46 +0100
Message-ID: <20241203141928.809395699@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 90868df7865e3..adcaabf408949 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -763,10 +763,7 @@ static int do_eisa_entry(const char *filename, void *symval,
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



