Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6ED345730;
	Tue, 16 Dec 2025 11:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885031; cv=none; b=qbcDGxTh4mIRdblnsqjb+fc2FyJJeFjj7DcxwempkC2l4WZkPO3yeGs7Ssd/czUuXSjfNbsOUAdvYkP9FohDgjgOsHSSILg8juOs3gV6RLLTwVzkjLTqrf77B7qOigVxlsBUMDCZViCAXnXqPq8HP0RkfU5xE4CiQLLxkF2g16E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885031; c=relaxed/simple;
	bh=dl4FriRPdwElfT4JYQoMyaQkqiD0OHyUmCPGS5sxdNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/iWF272uk9SQhh6KwIfmcyGrzck5UBvE3aQ178jfuuTeN9CByeteiOvbUj0PPSkLS8ErQXO7uXAo3dCQE7OaOyJIZp4dPlOexT+a75VUFIKv//55lISbNKvVl9p4lzr/DwqWGQfDV9HNvyC2qtxKUNwSWjMatEQHSKhJ1nlAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMwyfnbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMwyfnbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C79C4CEF1;
	Tue, 16 Dec 2025 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885031;
	bh=dl4FriRPdwElfT4JYQoMyaQkqiD0OHyUmCPGS5sxdNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMwyfnbCINrSH1pBxj1P12uRpLccKmTmrH/jxqpb56JI/ukhE5MCiqpTGFyR++glf
	 5FVRe4SEY8IskalmysagOsSo4lT9z6nygU3iX0mgtZhrvWqFI5QigybSw7K9oxId59
	 UnzZkM6HD2pp2Ni67RhNt5OsIfe4PnrIeUqiYxt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 018/507] tools/nolibc: handle NULL wstatus argument to waitpid()
Date: Tue, 16 Dec 2025 12:07:39 +0100
Message-ID: <20251216111346.196643300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 812f223fe9be03dc22abb85240b6f075135d2386 ]

wstatus is allowed to be NULL. Avoid a segmentation fault in this case.

Fixes: 0c89abf5ab3f ("tools/nolibc: implement waitpid() in terms of waitid()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/sys/wait.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/include/nolibc/sys/wait.h b/tools/include/nolibc/sys/wait.h
index 56ddb806da7f2..c1b797c234d11 100644
--- a/tools/include/nolibc/sys/wait.h
+++ b/tools/include/nolibc/sys/wait.h
@@ -82,23 +82,29 @@ pid_t waitpid(pid_t pid, int *status, int options)
 
 	switch (info.si_code) {
 	case 0:
-		*status = 0;
+		if (status)
+			*status = 0;
 		break;
 	case CLD_EXITED:
-		*status = (info.si_status & 0xff) << 8;
+		if (status)
+			*status = (info.si_status & 0xff) << 8;
 		break;
 	case CLD_KILLED:
-		*status = info.si_status & 0x7f;
+		if (status)
+			*status = info.si_status & 0x7f;
 		break;
 	case CLD_DUMPED:
-		*status = (info.si_status & 0x7f) | 0x80;
+		if (status)
+			*status = (info.si_status & 0x7f) | 0x80;
 		break;
 	case CLD_STOPPED:
 	case CLD_TRAPPED:
-		*status = (info.si_status << 8) + 0x7f;
+		if (status)
+			*status = (info.si_status << 8) + 0x7f;
 		break;
 	case CLD_CONTINUED:
-		*status = 0xffff;
+		if (status)
+			*status = 0xffff;
 		break;
 	default:
 		return -1;
-- 
2.51.0



