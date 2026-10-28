Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207636;
	b=CxTz1dtCl0Hzk4geMFv7zBTNd0o3IU1lLsXAcKnqWex5v68EMbKXlCLqKLJACHRk/4LE
	 KU9LUpxbs8mov4iyMgTgQzUkywquG4N+n0Fh8idLBix5HfTflqvtTbOqxu0ycaTNujFdu
	 /6zah/KniRLBfCDbEv0spBfkCaOx351iXi9QACh7rnWnSGdPs6bscB3pynMeljCPzMlJq
	 8psqnCjTZIRJ+3vyqyTpNbshPgNg217E1SHUqXI6LWnYMx+G/9IROk5G6a8rdxzeshcP2
	 DjOEWy/itDY9dTCHx1cLHh1U/MtESHXl9xgXatapLcRcxAlSKDh8kvxSYI0v5SeaFfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTW02kLZMRwXlg9u3ULO3o+1h+06G8nOOqd0cpApkVw=;
	b=ZXwjkgVxPlVDspUBtge0iwQQz7MkwV74zMmKdqKBiE3t2Kely573W2Ia5jWhfsFm3DKA
	 lsuJ69ipcJkYZHuRceGXtIibQ4oXZZA5LU97k2MNsNT4yKanT2KkyiJi35x3J06AdojNq
	 x93DfaTboGYTW32+m5gcqy/P4Y6XSO6hlz0qZZiDzr+vrjvOJvCJ3A+JnoTw9c0rlok1j
	 sPEKIB6RGAt0BsPC5mYKhnP6HBtf3XSpwJs/u0/G28zt6JeUXw5nq7PUXFybTLYEgANI2
	 ai4OjKAeZmewReh1iY6ukUIjAND1irfGEi+sWW09P33dM/pKduMglNJpKbFDY61wP2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m90cCE2z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F82606A32F;
	Wed, 28 Oct 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m90cCE2z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C7D1F01825;
	Wed, 28 Oct 2026 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207636;
	bh=KTW02kLZMRwXlg9u3ULO3o+1h+06G8nOOqd0cpApkVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m90cCE2zYT+D0wt2dpuhs7tmISZSEF7gGzdeT6ywKbLDdkBKyLyBK/Bkqpm4rK+Uj
	 OhVD4NRVUxrO6Qji0LpPt0kbDEjH70bYS86AwYDNGMEHM/vgrlN7toJdwyAD6xJoxi
	 yBWliehBsU/zH0Oc2hirM0zgh6uzaQ61W/wMAgmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/247] scsi: st: Save the visited block for the partition the drive is in
Date: Wed, 28 Oct 2026 17:57:26 +0100
Message-ID: <20261028165948.390482513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurence Oberman <loberman@redhat.com>

[ Upstream commit c9e9f024dd4f61f0f6636c9f2ed0830f87060e11 ]

set_location() saves the current tape location before switching
partitions, so that switch_partition() can return to it later. It reads
the location with READ POSITION but stores it in the st_partstat of
STp->partition, ignoring the partition the drive reports.

The two differ after a device reset. When the reset is recovered with
MTREW, MTSEEK or MTEOM, st_ioctl() sets STp->partition = 0 and calls
switch_partition() to return to STp->new_partition. A drive that was in
partition 1 is still there, so set_location() files the partition 1
position under partition 0. The next switch to partition 0 locates to
that block: if partition 0 holds less data, MTSETPART fails with EIO
(BLANK CHECK), otherwise the tape is silently positioned at the wrong
block.

IBM ULTRIUM-TD5 (LTO-5), LU reset in partition 1 at block 1025:

  st 12:0:0:0: [st0] Visited block 1025 for partition 0 saved.
  ...
  st 12:0:0:0: [st0] Setting block to 1025 and partition to 0.
  st 12:0:0:0: [st0] Error: 402, cmd: 2b 2 0 0 0 4
  st 12:0:0:0: [st0] Sense Key : Blank Check [current]
  st 12:0:0:0: [st0] Add. Sense: End-of-data detected

Store the location in the st_partstat of the partition reported by READ
POSITION. With the fix:

  st 12:0:0:0: [st0] Visited block 1025 for partition 1 saved.

This is a pre-existing issue. It was not caught when testing the recent
st reset series because the partition test was only run on scsi_debug:
on the LTO drive it was skipped, since can-partitions is off in the test
harness's stinit.conf, as is normal for LTO. scsi_debug hides the
problem because its emulated tape returns to the beginning of partition
0 on an LU reset. It was found while validating a backport of that
series to RHEL 9.8, when the partition tests were run on real hardware
with can-partitions enabled. The same failure then reproduced on
unmodified RHEL 9.8 and on upstream, and the fix makes the test pass on
v7.3-rc3 and RHEL 9.8 with an LTO-5.

The harness (https://gitlab.com/loberman/tapetest, test X03) now refuses
to silently skip the partition tests on hardware.

Fixes: 7081dc75df79 ("scsi: st: Restore some drive settings after reset")
Assisted-by: Claude
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20261006164250.773840-1-loberman@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3e982c166baf9..95da0d15e0490 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3194,14 +3194,20 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 	    partition >= ST_NBR_PARTITIONS)
 		return (-EINVAL);
 	if (partition != STp->partition) {
-		if (get_location(STp, &blk, &p, 1))
+		/*
+		 * Save the location for the partition the drive reports,
+		 * not for STp->partition: after a reset STp->partition may
+		 * not match the partition the drive is in.
+		 */
+		if (get_location(STp, &blk, &p, 1) ||
+		    p < 0 || p >= ST_NBR_PARTITIONS)
 			STps->last_block_valid = 0;
 		else {
-			STps->last_block_valid = 1;
-			STps->last_block_visited = blk;
+			STp->ps[p].last_block_valid = 1;
+			STp->ps[p].last_block_visited = blk;
 			DEBC_printk(STp, "Visited block %d for "
 				    "partition %d saved.\n",
-				    blk, STp->partition);
+				    blk, p);
 		}
 	}
 
-- 
2.53.0



