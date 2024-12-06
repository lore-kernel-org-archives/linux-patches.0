Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D2F1514CE;
	Fri,  6 Dec 2024 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498566; cv=none; b=XEHqZ/tZge3WM55QppfvZE9ana8dL2IekeikkX/9dSmuX0JhA8hmsGDvQ6AhSjlA3LcqcOWcwQbfcBuYhvkI95Z/9ofcY6ozcBmxH8kg7spvb9+0labeAO4yv9/+umnQGYSqt7iEY5irH0b0/RXyRf0A7v7q+ezYldvWngi4KvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498566; c=relaxed/simple;
	bh=NoqTD5amL3GsBkeDnH7WuCeMp8KoIV2qeR2RBvmdMYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUjPFJCZ/jINUMW8eDw9VCBvJse+/zbGNhHfsOnq0Kz1XuuISFxGdAmGcEAJvX57Fp8vrO6u2J8Eph1sjaI3h8be5sf+gUT9LrGtvoN2z10z5YFqYYMhlO4ZsDOHb7tvsqY+bII5ybqQNWgDQ/r6OOuudQF/6hUNAz8BjPhJnwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0d4shWfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d4shWfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967EFC4CED1;
	Fri,  6 Dec 2024 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498566;
	bh=NoqTD5amL3GsBkeDnH7WuCeMp8KoIV2qeR2RBvmdMYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0d4shWfMPIHsyS+xEDF64xm0phwZGE92HgSc29oIbvCcvkuqeXA6x24NDc/xOBois
	 kuGpwCKB2VFt1JDC8ln0KPx3mfVi7xb35JR1CCDmsDoW856fDnWadhTvYs09X6kBvG
	 DLbCcXlIhT+SE0M+uYLt9nBbbLo5LRK+TGB4BZqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 591/676] modpost: remove incorrect code in do_eisa_entry()
Date: Fri,  6 Dec 2024 15:36:50 +0100
Message-ID: <20241206143716.456767973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6583b36dbe694..efbb4836ec668 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -809,10 +809,7 @@ static int do_eisa_entry(const char *filename, void *symval,
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



