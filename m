Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025243;
	b=1ZkEBazeho1aswgQ9nCjSBBeXvMVsXe0BaJMDaVbFeqOyCoafS7NkA02OKyJEtlS+Qzr
	 bo0xVpe4wF9+j6yARBtazdRGnlNa8ebokzDHuz+sXh5i986BwKI99FGr6Kvgc7Brp1L5H
	 jtz1gZnp38eo2bg4G0W1GZKXtFGUQAp+6S14v18DTbSkZIZNUyCMza6ko224eoANRE8t+
	 8EfGOwpe1xAF6wqh4URY5p6hWmr0XPPkeLIJLAdr5VHauEqX5NdXkuIHZ+uKgHnC3Evkk
	 PwuIkQDqHPLudPp85nr3b49nSooMB+8nsTYCQh8zWk5ARDGmclgQ4MB4S2XJhX79L2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UU2h46aq/+8gYnYXQT7DzP/eBm89EybaVGXntn5yfIA=;
	b=xwsTwzsnHVKB6HHMrn8bt236JD/b5+XzBVeIETQjOkKvQRmQWpRh5CksJ+65FRAL0ACY
	 A+0N/mjCp7yXIO2vBcVQ0nwraYBw8O6AU/kZ9V1FZ1+J0jOogYg+4uC7u7Jmcwz0Fzq0c
	 gTcZlq1bT8d9dRcL1qjksWDd/hOMjT7nlR7nsVQ0j3jK67Oc9K9tuVMNz0QRPEzSwYzr4
	 xlNH6kNheanIO/sWGptQ7MAhxBdqplJ+vqc9jewNrwne9C58puuudhuUq8YJJa5KdJO+I
	 bhVFu+zMEiIAohuS48UxC2MB/IqK7/luj4JzL/+FUSDqmjRO4oEhfL0V/TX9iwcZ9wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvtdjB65;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092D9606A325;
	Wed, 18 Nov 2026 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvtdjB65
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D441F000C7;
	Wed, 18 Nov 2026 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025242;
	bh=UU2h46aq/+8gYnYXQT7DzP/eBm89EybaVGXntn5yfIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvtdjB65x8id0/drT13PNdMAwJf+foYm0pco4NRc+K3bniDdtf1ElvR117g8Awrax
	 MIEhAArFPhpqcQfxCBJWKQ35XgTY9n1X9APmvz02D/yq/Mupp3Etr/onkYh0makCip
	 6F4soLDi0UzvrEx3pfQKthcAjQUDxKpkszRFutms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1009/2151] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Wed, 18 Nov 2026 15:45:44 +0100
Message-ID: <20261118150159.190760600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c9aedbcbff0fe31fabdea09600609eb30e05441d ]

resp_comp_write() takes the data lock and then the zone metadata lock,
while every other command that takes both takes the metadata lock first and
reaches the data lock through do_device_access(). A COMPARE AND WRITE and
any other write to the same store can therefore deadlock each other.

Take the locks in the same order as everywhere else.

Correct the comment above map_region() while here: the provisioning map is
covered by the metadata lock rather than the data lock, which is why
resp_unmap() takes only the metadata lock.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-19-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 168babffc146d..60ed10fa1f7fd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5459,20 +5459,20 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 
-	sdeb_data_write_lock(sip);
 	sdeb_meta_write_lock(sip);
+	sdeb_data_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
 		retval = check_condition_result;
 		goto cleanup_unlock;
 	}
 
-	/* Cover sip->map_storep (which map_region()) sets with data lock */
+	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup_unlock:
-	sdeb_meta_write_unlock(sip);
 	sdeb_data_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 cleanup_free:
 	kfree(arr);
 	return retval;
-- 
2.53.0



