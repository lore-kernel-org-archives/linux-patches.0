Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA44113A25F;
	Tue,  9 Jul 2024 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524163; cv=none; b=uWkfZzcwDNiCO0NEujQnLz/TVGJPlL8KKzaYbAx7Ji51Q8ZR3S9rmAauSSKDi7rUXwhUrHfB5ygZxy6v+HHlLxwZB2C8QU6KRS43CAzrdtpCBKkwFeQ2qpbLhB8uart2twlVjBeq+0VCptlOLnktKq66dweJkhQZYIZ7x8ZeQig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524163; c=relaxed/simple;
	bh=FeBCMPBAl6jnTtTJAyJ+t5iAtb2iMcLYPo9UPpibQ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjRIFnWkAmNSjnIg26Ggmdk3cexZVq2z9k2Ak+7ysuBPLNyt9JvKkVFcL27OcpPe+1+CYS3l4J29MW4FKD/puBalEVXpcEE1hO9u3usPu1Pk4tEQyb9Pt+VVtTrErg1IliDMTrCNCnTkDL4b+/293s70/QJ8JqZETB6lPoYgKIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJ5LzkVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJ5LzkVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505B2C3277B;
	Tue,  9 Jul 2024 11:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524163;
	bh=FeBCMPBAl6jnTtTJAyJ+t5iAtb2iMcLYPo9UPpibQ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJ5LzkVcolqWQKWWi38iCyOcTe0D/2A28N9TnyMVUtTxYRfbOouY1bsosHrW4VxD8
	 6T7xygm2csAiJrfizrf+RPJJl6hHQTPK10L0A+pytEvOCgG7/y47zOYeSXkrhjfLtM
	 NKw5Ud6h5DYDIu9qvXMBtV/3r0XSdV1iDiSyDiwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Kurz <groug@kaod.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 064/197] powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"
Date: Tue,  9 Jul 2024 13:08:38 +0200
Message-ID: <20240709110711.439884302@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index d79d6633f3336..bd4813bad317e 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1350,7 +1350,7 @@ static int cpu_cmd(void)
 	}
 	termch = cpu;
 
-	if (!scanhex(&cpu)) {
+	if (!scanhex(&cpu) || cpu >= num_possible_cpus()) {
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		last_cpu = first_cpu = NR_CPUS;
@@ -2772,7 +2772,7 @@ static void dump_pacas(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_paca(num);
 	else
 		dump_one_paca(xmon_owner);
@@ -2845,7 +2845,7 @@ static void dump_xives(void)
 
 	termch = c;	/* Put c back, it wasn't 'a' */
 
-	if (scanhex(&num))
+	if (scanhex(&num) && num < num_possible_cpus())
 		dump_one_xive(num);
 	else
 		dump_one_xive(xmon_owner);
-- 
2.43.0



