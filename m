Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6B21509BF;
	Tue, 20 Feb 2024 21:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463072; cv=none; b=aDlsF6ZfAflK/jo6ja3Unkf3RWSoK+zEZXx/R6YdWo+LjCFPGGRnboEF8FEb0yK9znxuxitm+aNLKs4qn6OhkMI9QEGm9REaxrGgGaHd7fT12MC+jiKTy3WHDcFTDdB1VpXp52RcPSlSF/d5ikllHOlZHqPuXVJIt7si9RJpkKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463072; c=relaxed/simple;
	bh=9Gi6tddfhUQBb9S5XEBFQJ53N8YW+TuQBWH+zFcxJhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWeySsJQKA54X/+0wkYKJzXa5/dyifx6/4m5I5aGCW6ULIBf2mCeZmL38a5w+n5npTV24RbPUw9JKUUbGq+c1D1TidP7mGT8uVOVtYk2qWXar4pW2OQlI/GCR/OmqXZayCO0r3c4qQB21iYjhNk/PkxL2ngRNTanD03xWkQ4la8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyXkkkrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyXkkkrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B25FC433F1;
	Tue, 20 Feb 2024 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463072;
	bh=9Gi6tddfhUQBb9S5XEBFQJ53N8YW+TuQBWH+zFcxJhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyXkkkrLKelzZ3MpgvW6ahfAzWfB+bS0/RIy0aOI0NM7elfDCtlGVEIPsFJbbNebl
	 Pq3DKY7jcPj/NYGwm+8TVYb6DgXQQwTBjjel7WWS7yJcNKin5fDpf96GTbSpJJpBxx
	 Gdu2NjjTJ5BfDxw4IcJ88sYKslFgs6CnL6ud3gkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 126/197] powerpc/pseries: fix accuracy of stolen time
Date: Tue, 20 Feb 2024 21:51:25 +0100
Message-ID: <20240220204844.844226336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shrikanth Hegde <sshegde@linux.ibm.com>

commit cbecc9fcbbec60136b0180ba0609c829afed5c81 upstream.

powerVM hypervisor updates the VPA fields with stolen time data.
It currently reports enqueue_dispatch_tb and ready_enqueue_tb for
this purpose. In linux these two fields are used to report the stolen time.

The VPA fields are updated at the TB frequency. On powerPC its mostly
set at 512Mhz. Hence this needs a conversion to ns when reporting it
back as rest of the kernel timings are in ns. This conversion is already
handled in tb_to_ns function. So use that function to report accurate
stolen time.

Observed this issue and used an Capped Shared Processor LPAR(SPLPAR) to
simplify the experiments. In all these cases, 100% VP Load is run using
stress-ng workload. Values of stolen time is in percentages as reported
by mpstat. With the patch values are close to expected.

		6.8.rc1		+Patch
12EC/12VP	   0.0		   0.0
12EC/24VP	  25.7		  50.2
12EC/36VP	  37.3		  69.2
12EC/48VP	  38.5		  78.3

Fixes: 0e8a63132800 ("powerpc/pseries: Implement CONFIG_PARAVIRT_TIME_ACCOUNTING")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240213052635.231597-1-sshegde@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/lpar.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -660,8 +660,12 @@ u64 pseries_paravirt_steal_clock(int cpu
 {
 	struct lppaca *lppaca = &lppaca_of(cpu);
 
-	return be64_to_cpu(READ_ONCE(lppaca->enqueue_dispatch_tb)) +
-		be64_to_cpu(READ_ONCE(lppaca->ready_enqueue_tb));
+	/*
+	 * VPA steal time counters are reported at TB frequency. Hence do a
+	 * conversion to ns before returning
+	 */
+	return tb_to_ns(be64_to_cpu(READ_ONCE(lppaca->enqueue_dispatch_tb)) +
+			be64_to_cpu(READ_ONCE(lppaca->ready_enqueue_tb)));
 }
 #endif
 


