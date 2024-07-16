Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F8136643;
	Tue, 16 Jul 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144529; cv=none; b=oEqIBi3RHSQ08QxC7Eweo2LMPVvmNVTt3A3vWYI8gSGv+8QT+JFYdmY2SiSkZg2oaXchVahk4ojo7zEY9n/HNW/Ff36V51gB57YDbzSUHpGP8Qx7SSoDAY4nu9aFyglezhxLkO5KbNK0UFqSCraEEFVCLeL6EwNLZdII0BYJtQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144529; c=relaxed/simple;
	bh=K/Z78X4M7EqzFQtjqbBC8c9n+JrdZLs6ECdQJipKuFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BygEaKEIi7NywFDPDC1qjflzKxL62nEnC13Og4JT34mrk2Pd4yQeMCCjRSM8md7ltG9nGuGmmdwK9332mH3c9p+XedeIu/3Aw3M5T3HTICZx59yE0po1H1FS7aQ/gdKtDSNh7+nO2gBsppiVnq7ztnoXR8oE1zd513XnJuKY0VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYJnvZN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYJnvZN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A19C4AF0B;
	Tue, 16 Jul 2024 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144529;
	bh=K/Z78X4M7EqzFQtjqbBC8c9n+JrdZLs6ECdQJipKuFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYJnvZN+2Dr1XdqDSR0aPG+3rNkOtK9kgOCWAsTEydbxE39OTGA2ZRW6wnFEGd3rO
	 4Xtg1U6ebPh5t2WH6NOaSob/NcOTQVP52nLHNHuK/OEMQiUYhv7Ga7nUEsqO+npLnu
	 IbmvQPyJ/hyOZDE3o5T+wRNwoZZ07bM0mU+PWhpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Kurz <groug@kaod.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/108] powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"
Date: Tue, 16 Jul 2024 17:30:38 +0200
Message-ID: <20240716152746.891824852@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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
index 3de2adc0a8074..a2883360d07c9 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1249,7 +1249,7 @@ static int cpu_cmd(void)
 	unsigned long cpu, first_cpu, last_cpu;
 	int timeout;
 
-	if (!scanhex(&cpu)) {
+	if (!scanhex(&cpu) || cpu >= num_possible_cpus()) {
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		last_cpu = first_cpu = NR_CPUS;
@@ -2680,7 +2680,7 @@ static void dump_pacas(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_paca(num);
 	else
 		dump_one_paca(xmon_owner);
@@ -2777,7 +2777,7 @@ static void dump_xives(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_xive(num);
 	else
 		dump_one_xive(xmon_owner);
-- 
2.43.0



