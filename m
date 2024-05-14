Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CEA168C7;
	Tue, 14 May 2024 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684808; cv=none; b=ma+kh6ABvD+P3d/jGHy72ZhvsVafH/FGWdtmBXearC+GVaZFdBBOeRNGlHTrxbwDsWSuU76ykhuLY0v/TDknUDO53F39XA7r7Hmw1zeu9cpHfCtN3SPf14qmRsNaHFYVspavIcraAA4fZaRaiQQjVwnIuCFB3oND04rSBuehGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684808; c=relaxed/simple;
	bh=8VJahDqrGeENwyvHPnNMw6yDK7vh+3V14xUuDxckVJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERb3lwvHnigLOyHnihUGRU1H2CNqVl6XOQoTlvcY0D/sH67QDWgEs9jZhY0m2yLsm9+gJttVAmp8DpgkNCGBng8qx4y69HCj1hTB6P71Xo6iui4xSUwYqnuAvh5J+WJVhgeOHkMXoMqniIBZWI57HuFgrBbLZUJWob06CImOnhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3STg/Df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3STg/Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFF0C2BD10;
	Tue, 14 May 2024 11:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684808;
	bh=8VJahDqrGeENwyvHPnNMw6yDK7vh+3V14xUuDxckVJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3STg/DfHyBuNKCx3+0mUhbydvdmVn+zfMPAfvQMF0m7VqYkpnfbOlIfPCcOig8Gs
	 X2Rjp8pAdxdWs/qp5kQ5arbOUX+4d7zb8RpPC7D27lJnUp/nVjwFZzHleMEkXubeW9
	 DZlLM0pWgt3ZEvf/7hqNuk8OczJIYAnx0blkImQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/301] powerpc/pseries: make max polling consistent for longer H_CALLs
Date: Tue, 14 May 2024 12:16:02 +0200
Message-ID: <20240514101035.685265571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/powerpc/include/asm/plpks.h       |  5 ++---
 arch/powerpc/platforms/pseries/plpks.c | 10 +++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/plpks.h b/arch/powerpc/include/asm/plpks.h
index 23b77027c9163..7a84069759b03 100644
--- a/arch/powerpc/include/asm/plpks.h
+++ b/arch/powerpc/include/asm/plpks.h
@@ -44,9 +44,8 @@
 #define PLPKS_MAX_DATA_SIZE		4000
 
 // Timeouts for PLPKS operations
-#define PLPKS_MAX_TIMEOUT		5000 // msec
-#define PLPKS_FLUSH_SLEEP		10 // msec
-#define PLPKS_FLUSH_SLEEP_RANGE		400
+#define PLPKS_MAX_TIMEOUT		(5 * USEC_PER_SEC)
+#define PLPKS_FLUSH_SLEEP		10000 // usec
 
 struct plpks_var {
 	char *component;
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 2d40304eb6c16..ed492d38f6ad6 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -415,8 +415,7 @@ static int plpks_confirm_object_flushed(struct label *label,
 			break;
 		}
 
-		usleep_range(PLPKS_FLUSH_SLEEP,
-			     PLPKS_FLUSH_SLEEP + PLPKS_FLUSH_SLEEP_RANGE);
+		fsleep(PLPKS_FLUSH_SLEEP);
 		timeout = timeout + PLPKS_FLUSH_SLEEP;
 	} while (timeout < PLPKS_MAX_TIMEOUT);
 
@@ -464,9 +463,10 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 
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
-- 
2.43.0



