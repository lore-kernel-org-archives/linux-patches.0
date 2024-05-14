Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C910E139D1E;
	Tue, 14 May 2024 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686295; cv=none; b=j88Iq0guuoaZ0rEbVVKjwec5tvXLYyGKslv+z8LTGaWu/RejZkZXbLq3NLYA+GwoswvLqxdxf7mh1qSMuY6XQq1fqAERyOgsT0Ipva17eNOD0j4/hsAWgtaAiiRYv/UjepLbI4fqJKKIoeWvih/rEKEpMaQonShSt2kuvcIoM+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686295; c=relaxed/simple;
	bh=EMdXdT7sRAkDGkv2UFjuwiz4NzQYa7FYq3f5PbXYB5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TShAAqKbzKgHiAvWufZ2ovqgQo5tueXKoO0j4i4lefzUYlyMkLF5+Q9w9bYKqtUPxF17XE4/PKTJ3kReT2+zqrEgn8xiqVANOQ7fM1PZn9cOpmYtgRY13EYzsA1p3Q2a+Us4kTIY/QhCWpuWvD2XUwgnt462f+k0SDoZR4q+Ucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwajEyjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwajEyjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1096FC32781;
	Tue, 14 May 2024 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686295;
	bh=EMdXdT7sRAkDGkv2UFjuwiz4NzQYa7FYq3f5PbXYB5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwajEyjfyhPyyRec/AWSLPGQ/FweArsWZWDfvwWuokB8b83EekTgBRr2bfBuYZD36
	 TnBz0FLQPv3GSC3nQZ0zNdIKW2pJ+z7Idy15yHXnfIiQaTEbShfQnxzeJvQZbGrQXQ
	 D0qOGsqNYAM3i11QBXrzoBGmTW/VSvyF6tkBCm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/236] powerpc/pseries: make max polling consistent for longer H_CALLs
Date: Tue, 14 May 2024 12:17:31 +0200
Message-ID: <20240514101023.748734284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 784354349d2c988590c63a5a001ca37b2a6d4da1 ]

Currently, plpks_confirm_object_flushed() function polls for 5msec in
total instead of 5sec.

Keep max polling time consistent for all the H_CALLs, which take longer
than expected, to be 5sec. Also, make use of fsleep() everywhere to
insert delay.

Reported-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240418031230.170954-1-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 10 +++++-----
 arch/powerpc/platforms/pseries/plpks.h |  5 ++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 3efbfd25d35d0..453c3cdd81fb8 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -263,8 +263,7 @@ static int plpks_confirm_object_flushed(struct label *label,
 		if (!rc && status == 1)
 			break;
 
-		usleep_range(PLPKS_FLUSH_SLEEP,
-			     PLPKS_FLUSH_SLEEP + PLPKS_FLUSH_SLEEP_RANGE);
+		fsleep(PLPKS_FLUSH_SLEEP);
 		timeout = timeout + PLPKS_FLUSH_SLEEP;
 	} while (timeout < PLPKS_MAX_TIMEOUT);
 
@@ -311,9 +310,10 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 
 		continuetoken = retbuf[0];
 		if (pseries_status_to_err(rc) == -EBUSY) {
-			int delay_ms = get_longbusy_msecs(rc);
-			mdelay(delay_ms);
-			timeout += delay_ms;
+			int delay_us = get_longbusy_msecs(rc) * 1000;
+
+			fsleep(delay_us);
+			timeout += delay_us;
 		}
 		rc = pseries_status_to_err(rc);
 	} while (rc == -EBUSY && timeout < PLPKS_MAX_TIMEOUT);
diff --git a/arch/powerpc/platforms/pseries/plpks.h b/arch/powerpc/platforms/pseries/plpks.h
index ccbec26fcbd8b..b3c3538b229c6 100644
--- a/arch/powerpc/platforms/pseries/plpks.h
+++ b/arch/powerpc/platforms/pseries/plpks.h
@@ -42,9 +42,8 @@
 #define PLPKS_MAX_DATA_SIZE		4000
 
 // Timeouts for PLPKS operations
-#define PLPKS_MAX_TIMEOUT		5000 // msec
-#define PLPKS_FLUSH_SLEEP		10 // msec
-#define PLPKS_FLUSH_SLEEP_RANGE		400
+#define PLPKS_MAX_TIMEOUT		(5 * USEC_PER_SEC)
+#define PLPKS_FLUSH_SLEEP		10000 // usec
 
 struct plpks_var {
 	char *component;
-- 
2.43.0



