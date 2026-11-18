Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041669;
	b=veibJrFJnxSLESuPn7Q4mCq8slcm1DrInLHsfJFQlggH67iYXJGJ0zMVvjOr8c7SgGdg
	 yej0tinZ5gB/2jKd1ObmQwQdGjoV55i7mFAGsbGUQf+VfVfjn1AGMlbxKM7KjqIsn/AOd
	 oESzdB6HqYMvA5QxYuUGm1iZwpoPvrtoLUOXDrvXUKN+WZzI3kq4QnipBJOZcM8kMd53U
	 aplgWG2aSDfR22Rm9eKXnQLOfgK7w6F1enR75ES9Dc45VcWv6IZYqRiCPTi4c2/0fetu6
	 Gl7tiwcEsBxLvU8jbL8inDbe86As1SaGLL5HPGpysKmqhEtdUIDotyZpgDMCJLMDiIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SHasddK0bv01rjBzN1CAnUap5ZbD0QLOZncbbBQiQOE=;
	b=L8V6+aBs9MTr2udpBtnKcZLH5GK557q6MiytoToyzMugbGXmRJ7V9yEocbInTKnVGVi4
	 qZYQ0n2Jk3YmQLDgUgIQV/u+u2+SApGs5+hGJSGzcyQmi6jkVOwSGzelb5VaGcjBnOObk
	 rav3/xmEHCveEENGua1YYkv8i42aix/ExRwzCjodu1g3XTvWyqmVHbzz7OKwpaHuC+z/K
	 9BkEyCGpk55UV5m7iqgBJ5z939kxxiTcdPF36p1GdPyUKqu37H1Y9CJemelPpXHWjBaZA
	 R2wGTkSw0bWhWJui84QwDZzwc5lwbLY9LsPsOk97muEbfl5cEJlO/XZ2u2ZqQYwa6tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3hwUxEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CBC606A320;
	Wed, 18 Nov 2026 22:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3hwUxEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB781F000C4;
	Wed, 18 Nov 2026 22:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041668;
	bh=SHasddK0bv01rjBzN1CAnUap5ZbD0QLOZncbbBQiQOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3hwUxEU7VBvGVZJoVrKuMMznuRnYjpicT/QnSK+6N5uC5K40/euFoLUv16gjXo7v
	 JnwyDBFBKL5fhRPLwGgiokpFCUH3YLbLeQfBHtVKyJQlqJgKSlVdmke2SJJQ4qlmRt
	 JbE2OuBNvpOowhnW2BAss26a9IaJ8KNeKbDZqgew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2854/3318] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150446.220017608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8db79ea07a67b126c773da6efdc00066000daeb8 ]

pmz_status_handle() sets PMACZILOG_FLAG_BREAK from RR0, and
pmz_receive_chars() clears it on the null character that ends the
break without marking that character, then tests BRK_ABRT in RR1,
where the SCC does not set it in asynchronous mode. Breaks therefore
arrive as plain NULs: brk is never counted and BRKINT, PARMRK and SysRq
never see them.

Set BRK_ABRT in r1 for that character, as sunzilog does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-3-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 6fc6b9b93e0f1..b871c813f278b 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -233,6 +233,7 @@ static bool pmz_receive_chars(struct uart_pmac_port *uap)
 		ch &= uap->parity_mask;
 		if (ch == 0 && uap->flags & PMACZILOG_FLAG_BREAK) {
 			uap->flags &= ~PMACZILOG_FLAG_BREAK;
+			r1 |= BRK_ABRT;
 		}
 
 #if defined(CONFIG_MAGIC_SYSRQ) && defined(CONFIG_SERIAL_CORE_CONSOLE)
-- 
2.53.0



