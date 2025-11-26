Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1C51E231E;
	Wed, 26 Nov 2025 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764177068; cv=none; b=cp1ifc0itN3fTSgqHjOf50rpBCXtA4sNx4KLftZ5irMOgQMZtsoLoH4eWfJ9jvvrOGTe69YtE2Yt+noKb1t90QGMAxERbNFMCEAW0XxGfvzu8/bYI2e9mz85jN45S66DpnoFpllOozmuq8tx+czMgPtEYn16oTsMHSydn8wR9kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764177068; c=relaxed/simple;
	bh=+MziezalzLhgHTkPg5jAHvo3sHmJxoi9k7Z+XbQ9GE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYzJY3VraeAHSddP7Dx0y+Q3B/1b5qkKb0GpaXzU2OR4EA6eJQU2e4Kd53J1QoW7A0qRpkS7g912PCyxWhqtcIcTX23XWMAGBIFI/CG+WgKwfmBUrUTR9GtoTYApBCOQXMfHpyWUg50r+wd3cJ5wIriyHZptGUTODGV/ObD0D9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R+UWMgGv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R+UWMgGv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gHCa+irjrAJ1/TqpGbdSGXePtHe0se5Cnni6DX8TQMM=; b=R+UWMgGvazrV8k2pJB8KdaNsfK
	9B1Fe/B+KFpFioxevAzoynD+iKyh4/g1c/595TXB1H6UjVtNOajOuhKwSPg1D/+lTVV/ip/U700Bl
	9GeuJNMdAuSHVGvDf5Tco9c6kjbK+6867IfefRbkdykgmIi3lg+SsrX6ffOlXjsvz3QipnMNqbkN4
	AhaP8zNXh21scMnK/2sp3oNiySeE8GIXRSQg8MIK4ZnLS4Qij78LdbvstBHZK+4Cui1vcVqPVOsHm
	1fsREU7Pt15K7htd52FfIRUnFA6VuhE6abqXZKUEeZxRgdC8LyMsFDqsuqSrBnCVQbIL85Y+aFoc5
	S4gEqAPw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOJ2m-0000000FNAN-1YFg;
	Wed, 26 Nov 2025 17:11:04 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	sw.prabhu6@gmail.com,
	kernel@pankajraghav.com,
	bvanassche@acm.org,
	mcgrof@kernel.org
Subject: [PATCH v4 2/2] tests/srp/rc: replace module removal with patient module removal
Date: Wed, 26 Nov 2025 09:11:02 -0800
Message-ID: <20251126171102.3663957-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126171102.3663957-1-mcgrof@kernel.org>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Bart had put the remove_mpath_devs() call inside a loop because multipathd
keeps running while the loop is ongoing and hence can modify paths
while the loop is running. The races that multipathd can trigger with the
module refcnt is precisely the sort of races which patient module
removal is supposed to address.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Rebased-by: Claude AI
---
 tests/srp/rc | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/tests/srp/rc b/tests/srp/rc
index 8585272..2d3d615 100755
--- a/tests/srp/rc
+++ b/tests/srp/rc
@@ -331,19 +331,10 @@ start_srp_ini() {
 
 # Unload the SRP initiator driver.
 stop_srp_ini() {
-	local i
-
 	log_out
-	for ((i=40;i>=0;i--)); do
-		remove_mpath_devs || return $?
-		_unload_module ib_srp >/dev/null 2>&1 && break
-		sleep 1
-	done
-	if [ -e /sys/module/ib_srp ]; then
-		echo "Error: unloading kernel module ib_srp failed"
-		return 1
-	fi
-	_unload_module scsi_transport_srp || return $?
+	remove_mpath_devs || return $?
+	_patient_rmmod ib_srp || return 1
+	_patient_rmmod scsi_transport_srp || return $?
 }
 
 # Associate the LIO device with name $1/$2 with file $3 and SCSI serial $4.
-- 
2.51.0

