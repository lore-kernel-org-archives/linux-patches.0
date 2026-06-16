Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F9138C437;
	Tue, 16 Jun 2026 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635243; cv=none; b=ZmexvTPot5ssyrweWAC7Q6P3/zdBiknF9XQeRsdbhoDWKhmAnqPNBNPWlC1NJEO72nwjAidNN6yXjs17JNwjvVm/1w78tfP1Kx3XaDHlh8YCAEnNwlWH/RNIJiiAsU17yaDpShUMbS8K4LdOKYUL9r/w4zxo0Ot/9b1VVm5jwM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635243; c=relaxed/simple;
	bh=f1Vsv7ZsJ+t2awavpSU9OykL3Tk68RtFnk27ng8HPoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYOu97pzHG4DOx09eBykSJQr4qLeHIZYZ16MK8gHSLZexgKYykHIAO6dtFgQcKnELQelOMxuA+5ZCWpCQkUF+khrDOrXTOPuWhOdbvKaJHJliFdgXTa2+l57YeVajZQrepJg2EhhqMDxpCvvF8XpOlazDDD2s3cKoEgoWaQmmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leNimAZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leNimAZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51061F00AC4;
	Tue, 16 Jun 2026 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635241;
	bh=9hMeam5SD3OfNrSmQnxZS4O8Gd4mxGvNHqlqE3nmQuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leNimAZkc2213IQ+Clivw6Fh3dN+W63WOQ4YRnVkUAX9EoReLnR7zDARsbyDIXTSP
	 asOj7QEFebku9wGackCGb7uzwqDwJGY89+6TtagSSV2xxFxP7bpyoeN/e28fc0J6pu
	 yU3zhFh9Eu72Oegx39Rz/izyxCO+5bQvaE3twIiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.15 407/411] arm64: errata: Mitigate TLBI errata on Microsoft Azure Cobalt 100 CPU
Date: Tue, 16 Jun 2026 20:30:45 +0530
Message-ID: <20260616145122.780024960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 1940e70a8144bf75e6df26bf6f600862ea7f7ea1 upstream.

Commit fb091ff39479 ("arm64: Subscribe Microsoft Azure Cobalt 100 to ARM
Neoverse N2 errata") states that Microsoft Azure Cobalt 100 CPU "is a
Microsoft implemented CPU based on r0p0 of the ARM Neoverse N2 CPU, and
therefore suffers from all the same errata.".

So enable the workaround for the latest broadcast TLB invalidation bug
on these parts.

Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v5.15.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |    1 +
 arch/arm64/kernel/cpu_errata.c         |    1 +
 3 files changed, 4 insertions(+)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -291,3 +291,5 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Microsoft      | Azure Cobalt 100| #2253138        | ARM64_ERRATUM_2253138       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Microsoft      | Azure Cobalt 100| #4193789        | ARM64_ERRATUM_4118414       |
++----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -929,6 +929,7 @@ config ARM64_ERRATUM_4118414
 	  * ARM Neoverse-V2 erratum 4193787
 	  * ARM Neoverse-V3 erratum 4193784
 	  * ARM Neoverse-V3AE erratum 4193784
+	  * Microsoft Azure Cobalt 100 4193789
 	  * NVIDIA Olympus erratum T410-OLY-1029
 
 	  On affected cores, some memory accesses might not be completed by
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -250,6 +250,7 @@ static const struct arm64_cpu_capabiliti
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3AE),
 			MIDR_ALL_VERSIONS(MIDR_NVIDIA_OLYMPUS),
+			MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 			{}
 		})),
 	},


