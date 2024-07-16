Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F31F19EEC4;
	Tue, 16 Jul 2024 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146025; cv=none; b=EhjGjpIG7i0AOGiaK38yoZn8WD3sfwporhqNBABcofjVDE/6bjymysouWVNHk696iKWCf+Ui2zDWOG68eVRgDO5PnGqc2dm/jaF8D7inKQw9ga5bDBjjcsSiATRAa+Qs0Uk9P8lRPOAKyo8yKhkhsz0O7qbROhHWOSEZHWI9rA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146025; c=relaxed/simple;
	bh=3VoESR0NXDS24Fo27KTrxOEU4NaMCf6yH1k4so0W1KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJOF8VMR7EENk1IdmFXbFYLZIJjwt2zq6OUdG/+K0FuytoGvEogYNhmJlK2MC9lU1wp0o5B9ac9PNGDUG0mElop5rBF66rOGjHtcJgW8JAPt7GYrOa9/ZG653vIG2o/fnxXEzaNUPy2CoEb4YEoZhHKsjT3EfVAaSq7d0We+IQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMHR4Uro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMHR4Uro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05786C116B1;
	Tue, 16 Jul 2024 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146025;
	bh=3VoESR0NXDS24Fo27KTrxOEU4NaMCf6yH1k4so0W1KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMHR4UrouPhjD7Nk58N+sTGqAxWq5rVrQxnFuspYRaQfQuM1urq8Evncj+tw8bwbw
	 yXx0+YKIHzRfVk0VDxWGbNbbZvOUcqJGUT45RJRPIjw8bHLQCgO3l71ngGFtz+OyVQ
	 oHYEMoX4g0IRbqHX4ljh4CaK5ecwHjMV9tXll/M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Kurz <groug@kaod.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/144] powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"
Date: Tue, 16 Jul 2024 17:31:34 +0200
Message-ID: <20240716152753.505659315@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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
index 8b5277c3b1476..4178d5e8b42d9 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1356,7 +1356,7 @@ static int cpu_cmd(void)
 	}
 	termch = cpu;
 
-	if (!scanhex(&cpu)) {
+	if (!scanhex(&cpu) || cpu >= num_possible_cpus()) {
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		last_cpu = first_cpu = NR_CPUS;
@@ -2771,7 +2771,7 @@ static void dump_pacas(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_paca(num);
 	else
 		dump_one_paca(xmon_owner);
@@ -2844,7 +2844,7 @@ static void dump_xives(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_xive(num);
 	else
 		dump_one_xive(xmon_owner);
-- 
2.43.0



