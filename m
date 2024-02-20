Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AB4151CCC;
	Tue, 20 Feb 2024 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465167; cv=none; b=X8lyCuiY0mtFY98L3D66mjbaHoEI3l4IcVg0IjDQZHCO5wtjzVXHyRYNTy8sXR1h2qwm3bpgJzavmL6FQovSsplYWlYOxJX1GxaWw5uxSrnw5so8sYJH3JuzAex/J1IU5B8ZjmRxl8ZMX2FonXTYrqul3u/V9JFIyeQpoHTzopY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465167; c=relaxed/simple;
	bh=U0hj9ll/acNXeIFTSOFCpuhCsx2fa3Xs2QqL9zDOf8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb7f9OAafb3G9IBK98WaYpNztv0+2+IGqInRr1nO/FV4mn8/IPne9OACBIqXVslp7PaTMTfhsGFfrTG+Ik5vzODc6EwuX02Z/le4mRPdWF7k/OHoBwzrV7zBMXHCtHywOWO7dfeB2xoz5YbffPjKRqoejnlwC6e38kIloHJeTLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epG2JWKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epG2JWKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5344C433C7;
	Tue, 20 Feb 2024 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465167;
	bh=U0hj9ll/acNXeIFTSOFCpuhCsx2fa3Xs2QqL9zDOf8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epG2JWKM7puU4rGTxWlKfXGS94j0isAq0kmkOhdGasWWTIl9zSuHADhXEMsaOE8k3
	 3mWhTm65gtGOGxXq0acLPqNhlfyf2RyqUZUO6bDb69XSfvxckgYhppXFg3AsC1wSxb
	 aniyvh4W2QFPFv9dvm4LCtAVG3nfSzUVv//CjWGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.7 228/309] powerpc/pseries: fix accuracy of stolen time
Date: Tue, 20 Feb 2024 21:56:27 +0100
Message-ID: <20240220205640.289435546@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -662,8 +662,12 @@ u64 pseries_paravirt_steal_clock(int cpu
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
 


