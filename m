Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626012;
	b=NIsCuPKudNnrmC6gUk0HUcxyGUVoo01u0MPvL+xuUG2DufcO7tOOrazxxsqS0dWhs8qZ
	 jNA8xL7MoS99V1aPDN5atmknhs8172DpZVNYItClvxu8HbSrghHzVFQxrABIBkiXunrZb
	 99qDQkJqM0/hfXVuzLJB6J2iklhQO3zs5ZCGNNnPAf3zU/bt/cRWK1RF8urOxECx1nczi
	 kgN0F5whFt7wI36vWf1WHHKgR4e3Is+DKNE+yCzHJPcekUacIvo9++lhv8QZvhAm9HfIy
	 BooLvknmfmg87KnEo6lowMID9pB1OcpvDUZuR/4JYv0UFojN08+nZus8j8emcN4L82A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=amfXi1nUUqJREhc5ze7DpaWLH37ip6wDcOTGyGwWMD4=;
	b=QUINY6tNISg5aVhdwZWeWhRLyscXPLUTZ07QhdXze9JcYO3lbjdkjJ6FddARd94/4JwU
	 7ENXpByerrFWESYzYTl00RXLH5I3y0F3zA4Wu2IaHx5sPI4k4/Up40QDvPjKMk+tNNV+k
	 uuBNQKSqMaNUhkXyE2Ik3Mc88WUc+66MSp+OrS7vuK2oNd2Wm06KQC1oGDCc/c31ro4Rj
	 59TytymaLTUTmK5oxofxuraRzwW8jRG1hCfSIJNnvEH8CUG1U3Q2Ck0VSLaVAQ/+wMYE0
	 5pDNXFCa3MDwNHi9rxGRcQ80vyPwmAxQzpG4mYKUaOvS7VCdvnjwMXkjljSaDOBOFTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYPfkNXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC48606A321;
	Wed, 25 Nov 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYPfkNXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41641F000D8;
	Wed, 25 Nov 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626011;
	bh=amfXi1nUUqJREhc5ze7DpaWLH37ip6wDcOTGyGwWMD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYPfkNXzAWbaYdmFvIB2E5dDVacdhGoP5lLfbpmJAWh/upx8NFCYxUjGc2WWqnzir
	 vVUhlXCofFHp88X+dW3xO3sIBboAOZ7c5UmP1Jj9ZQ/loLuVFZTClnX5TYz61BBZ5k
	 5wl8x35auNMUmejrRqtsecSIUGGDMj6XMLh8qHug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	"weijiang.zhou" <weijiang.zhou@unisoc.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 700/816] dm-verity: dont restart or panic on errors during system shutdown
Date: Wed, 25 Nov 2026 15:37:28 +0100
Message-ID: <20261125143905.385732782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Weijiang Zhou <weijiang.zhou@unisoc.com>

commit 47930d1236d2988cdc580c10d3af21b6b02d7ece upstream.

Commit 252bd1256396 ("dm verity: skip verity work if I/O error when system
is shutting down") stopped I/O errors during shutdown from triggering a
restart, since devices may legitimately be gone by then. Errors that reach
verity_handle_err(), e.g. through a failed hash block read followed by a
failed FEC attempt, are not covered and still call kernel_restart() or
panic().

During a reboot that is both wrong (nothing is corrupt) and harmful: it
races with the reboot already in progress and replaces its reason with
"dm-verity device corrupted", which bootloaders such as Android's treat as
a verity failure and switch the device to EIO mode.

Apply the same shutdown check in verity_handle_err(). Corruption is still
logged, recorded in hash_failed and reported via uevent, and the I/O still
fails.

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Signed-off-by: weijiang.zhou <weijiang.zhou@unisoc.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 252bd1256396 ("dm verity: skip verity work if I/O error when system is shutting down")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -229,6 +229,15 @@ static void verity_hash_at_level(struct
 }
 
 /*
+ * Skip verity work in response to I/O error when system is shutting down.
+ */
+static inline bool verity_is_system_shutting_down(void)
+{
+	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
+		|| system_state == SYSTEM_RESTART;
+}
+
+/*
  * Handle verification errors.
  */
 static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
@@ -277,6 +286,15 @@ out:
 	if (v->mode == DM_VERITY_MODE_LOGGING)
 		return 0;
 
+	/*
+	 * Devices may already be quiesced (e.g. UFS set offline by its
+	 * shutdown hook), so a failure here does not imply corruption.  Fail
+	 * the I/O but do not restart or panic, which would also override the
+	 * reboot reason of the shutdown already in progress.
+	 */
+	if (verity_is_system_shutting_down())
+		return 1;
+
 	if (v->mode == DM_VERITY_MODE_RESTART)
 		kernel_restart("dm-verity device corrupted");
 
@@ -579,15 +597,6 @@ static int verity_verify_io(struct dm_ve
 	return 0;
 }
 
-/*
- * Skip verity work in response to I/O error when system is shutting down.
- */
-static inline bool verity_is_system_shutting_down(void)
-{
-	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
-		|| system_state == SYSTEM_RESTART;
-}
-
 static void restart_io_error(struct work_struct *w)
 {
 	kernel_restart("dm-verity device has I/O error");


