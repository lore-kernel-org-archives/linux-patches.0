Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F264E54C;
	Tue, 16 Jul 2024 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144119; cv=none; b=dI+p7mzOtPvEg+2IFiS20zugmLoNjbORisnGUKT8qkLeITtHaLhGwM7BKhKU0bemRnswLwD/aWK+IiMEow7Uk11Zno/wS5h880SbX7Rqnzy5ekd+LAe1MOCOViNodXNBVB2LF9uO3+WuHaAthebeSFKk0E3gU3QnpvbQBtXt8o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144119; c=relaxed/simple;
	bh=gBAaErAyb8GSdWcpjpqfpelI4AoMKvlUyk5Pl60fZTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRCG2XlNpx0SGcsb2FOXiX4x455BHZPoJW+4+01lPfBGIwEmq1+kzm47nbyQUEA0tF1QKj1OHWdGz42TiCiD+zOCxM05Il6ykYXPVvlZ2W/UMBvilE8ytCcjcgxSuR+YXKDsfDkRY6wywmIWxZPbPHvryOasco8eY7EZRxox2n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1bPwCIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1bPwCIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB73C116B1;
	Tue, 16 Jul 2024 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144118;
	bh=gBAaErAyb8GSdWcpjpqfpelI4AoMKvlUyk5Pl60fZTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1bPwCIoYDPYbcDCJkrQjOS0AeLmETBbxKn/Dl+3ajAL7U+vkgwSiCRbSCjNjl0VO
	 CLMDHja7B53J13AcQOg38WPFl5djd880NY5RADRjkDLNoPA+1mi4EBzp7bPNRKdIiS
	 zectr7cZZkFcjLUUoKR3zF3VCgCcnFJ7a3ZfJH0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Kurz <groug@kaod.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/66] powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"
Date: Tue, 16 Jul 2024 17:30:51 +0200
Message-ID: <20240716152738.782602270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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
index 3291e5fb94bcc..cd6df90dc6720 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1154,7 +1154,7 @@ static int cpu_cmd(void)
 	unsigned long cpu, first_cpu, last_cpu;
 	int timeout;
 
-	if (!scanhex(&cpu)) {
+	if (!scanhex(&cpu) || cpu >= num_possible_cpus()) {
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		last_cpu = first_cpu = NR_CPUS;
@@ -2485,7 +2485,7 @@ static void dump_pacas(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_paca(num);
 	else
 		dump_one_paca(xmon_owner);
@@ -2568,7 +2568,7 @@ static void dump_xives(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_xive(num);
 	else
 		dump_one_xive(xmon_owner);
-- 
2.43.0



