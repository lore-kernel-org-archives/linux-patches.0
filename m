Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59BF21504F;
	Thu, 12 Dec 2024 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016444; cv=none; b=IjdD5G07BlRN2Wz9bbgpoIOsh6MG0r1NQsqFXmvcrSlB+oQYSPeLDMolRWqzKbSIKwFRyw1EsBVcBBgH9oUdZ8QTuiRq1iUPoAti5vS0CgyVOlF2hmpO6aCvPuOdQsLA0FikEGmWYqLTakCypXORMnXs9cRixxJFUokiYy7xbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016444; c=relaxed/simple;
	bh=41M2TUDonI35Ut9T+NtcO1XNxiomeZxGWqNHliAtB54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm3V5WUr8+YNj1LCqKS9U/NaevI9ZDtudS7qTr0H4kwxzbS9qMMCAhgKstKbFyI8kp5MTvpn6TpAHDzfCyT/pNjgjBBKOpPIeEhJ9EkQH4A87rmLDfJuqioXrcWWcZt7PgugWlfYxum3n/JZA342qV/KixYcbCU4hLuJPf7A0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EySWTsKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EySWTsKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186BEC4CEE4;
	Thu, 12 Dec 2024 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016443;
	bh=41M2TUDonI35Ut9T+NtcO1XNxiomeZxGWqNHliAtB54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EySWTsKOiAfYoKgOT1d2jsUTojFBZqR9HFUnUwlJo6WPfTX+JVKajv63/FZ1NlXOT
	 4Hhk5VCoDWSBRXjGz38rICglLAYW4p/fmgwVjHadt7+ii3AZEv8yMf40LdBo7jXdaJ
	 9jlm7eXksAcKquE4dBYz/gB/mpMjrwSgdnOUmHPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 201/466] x86/cpu/topology: Remove limit of CPUs due to disabled IO/APIC
Date: Thu, 12 Dec 2024 15:56:10 +0100
Message-ID: <20241212144314.731436947@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

commit 73da582a476ea6e3512f89f8ed57dfed945829a2 upstream.

The rework of possible CPUs management erroneously disabled SMP when the
IO/APIC is disabled either by the 'noapic' command line parameter or during
IO/APIC setup. SMP is possible without IO/APIC.

Remove the ioapic_is_disabled conditions from the relevant possible CPU
management code paths to restore the orgininal behaviour.

Fixes: 7c0edad3643f ("x86/cpu/topology: Rework possible CPU management")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241202145905.1482-1-ffmancera@riseup.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/topology.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -428,8 +428,8 @@ void __init topology_apply_cmdline_limit
 {
 	unsigned int possible = nr_cpu_ids;
 
-	/* 'maxcpus=0' 'nosmp' 'nolapic' 'disableapic' 'noapic' */
-	if (!setup_max_cpus || ioapic_is_disabled || apic_is_disabled)
+	/* 'maxcpus=0' 'nosmp' 'nolapic' 'disableapic' */
+	if (!setup_max_cpus || apic_is_disabled)
 		possible = 1;
 
 	/* 'possible_cpus=N' */
@@ -443,7 +443,7 @@ void __init topology_apply_cmdline_limit
 
 static __init bool restrict_to_up(void)
 {
-	if (!smp_found_config || ioapic_is_disabled)
+	if (!smp_found_config)
 		return true;
 	/*
 	 * XEN PV is special as it does not advertise the local APIC


