Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886B4265CC8;
	Tue,  8 Apr 2025 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110660; cv=none; b=P+WeFIDJMMig4o7jjtNNvg5AEXEbZB1KDU5TUogcmV3RfxqW/vVpMb5MWNxr4wtrIR5mn0SP89ONVbZv8raks1GSi89KIyjWme+3/fVLh7EciS0wjTuCiGUAnv/twIXzVUEqVBh8xHpdhID8lLLbJZnpRaAkrcVj/CGoijGHKpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110660; c=relaxed/simple;
	bh=X1WX7Pv28BUzfkux0E0av37ucjEoHPCX24/9iGF/bl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRm4QbRcq8JO09UZOM7l6duEpflmpheSOdT2nCBSHYRUbxvRRUmMU3GEbkV88EffcEIPAcM7F4ZpvI32gdzwTZ6tZKl28HcGglldLBiiMAGs3SVCzPB5U10i8Y3puzTmYSlX1zjBGUR0Yn8JIKg3R06QPg8WWp5IUHirUj2eNdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLcob1uG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLcob1uG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF8BC4CEE7;
	Tue,  8 Apr 2025 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110660;
	bh=X1WX7Pv28BUzfkux0E0av37ucjEoHPCX24/9iGF/bl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLcob1uGAwP0mjZBEOyqZiSI1KpzXHoUgOT6Wg8hb6OHJVKMBJklo/E/EDCXd3JTR
	 aq4u0yZPzMinD7sEcutKFGrrIueqjCEteDc5iGio9cSDTAgftCfo732rEHFVFKN2su
	 NKVEocSYwMXYOQ/EOFGzS4SzAeDqXRgsxY0mMoSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 146/731] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Tue,  8 Apr 2025 12:40:43 +0200
Message-ID: <20250408104917.670970102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 3db4404435397a345431b45f57876a3df133f3b4 ]

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/linux-raid/20250306094938.48952-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c897b19dc2d53..918a09f0ddd45 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1623,11 +1623,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
-- 
2.39.5



