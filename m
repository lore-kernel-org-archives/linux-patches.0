Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AADF158A06;
	Tue,  9 Jul 2024 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524583; cv=none; b=s5k4Vhqzty7e3x8YgD/LD3mspTjS27S2IHSrIvTtcGuMeCFvCp+KYYknBfv00GmZwfUFQ8WrSKQXq0T2fFj1c0ERRr/JjIbY8ZfbiqE3g6Iy/Hf92Qt4pEu7mDQAn6bDh8wZZgsf4yLv6ICuN0zyiY6lhHY8ZhVeL2pr+lFw5yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524583; c=relaxed/simple;
	bh=tSQAPCaSj018c1gXWnIVjVb98/5t5JNdk+gDz+C2lrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFZiYTCDr7RQg9kJlF3ioKKqqawwxO1o3A9uP3sAHHwu9Ylx97MoHEq/DrMQTSbkoTmb+XoFJTxyJ4haWEMrHkLUpsUKGS5dCcHOES2Tng1KW0sDuV1ufkzpHo8lp60T8QgqQch4dGclqxc2tuXAGejbwDs5+FFCTSNFeqQ+3jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W70ZqfnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W70ZqfnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52C0C3277B;
	Tue,  9 Jul 2024 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524583;
	bh=tSQAPCaSj018c1gXWnIVjVb98/5t5JNdk+gDz+C2lrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W70ZqfnOY78mMVvdMo8ra4CWWG89iHsdB9nJjNUZOvKG0elQZ1CiNaRzwGy6rJC0b
	 QvN5UBKTYqrtBSBSL0CAcKjXGiatqdpf1S0RMb28z7Fq4TTMnYKaXH/F7P61Q9dL/T
	 eMa+7OGFgBg+jddP78eBqGDWZzuTvuS7LIX2NNoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Kurz <groug@kaod.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/102] powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"
Date: Tue,  9 Jul 2024 13:09:55 +0200
Message-ID: <20240709110652.620969129@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Greg Kurz <groug@kaod.org>

[ Upstream commit 8873aab8646194a4446117bb617cc71bddda2dee ]

All these commands end up peeking into the PACA using the user
originated cpu id as an index. Check the cpu id is valid in order
to prevent xmon to crash. Instead of printing an error, this follows
the same behavior as the "lp s #" command : ignore the buggy cpu id
parameter and fall back to the #-less version of the command.

Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/161531347060.252863.10490063933688958044.stgit@bahia.lan
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index cd692f399cd18..72307168d38ac 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1354,7 +1354,7 @@ static int cpu_cmd(void)
 	}
 	termch = cpu;
 
-	if (!scanhex(&cpu)) {
+	if (!scanhex(&cpu) || cpu >= num_possible_cpus()) {
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		last_cpu = first_cpu = NR_CPUS;
@@ -2776,7 +2776,7 @@ static void dump_pacas(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_paca(num);
 	else
 		dump_one_paca(xmon_owner);
@@ -2849,7 +2849,7 @@ static void dump_xives(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_xive(num);
 	else
 		dump_one_xive(xmon_owner);
-- 
2.43.0



