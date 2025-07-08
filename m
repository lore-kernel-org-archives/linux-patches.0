Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530C318EAB;
	Tue,  8 Jul 2025 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994177; cv=none; b=I/u0LWDvZoMGL6LofP3qRIYsQvbjcBUt5cD3kBoLSz1xrpH3WQycLdTZMJEESMVz3s0j4vMTZVSRtmvRkjFLWgtyzg6c5bKKRaOYKASsT5HfWay5gea/aUGNiQiA2QQRNxnq9iPoOUIFO8TPhL9Qorhnv8aXg5+X5uf0kjisVNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994177; c=relaxed/simple;
	bh=08M4hQHm12gPaSW7vst12y1ayxZ48Oo3hQuPdPHgZNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7yDdB6Jp+gqiWtvC0L9GKdECge7kKV7USrAucDVBGhEeXOR3uQ1GVW8uOIKc3I4SIYAJpg43R7TRm+axkcovbjtaHkjnWlNNeFLKh0ukssdwQuKB496ETOBZzU49WpNNhppcvbA43QHj0Q/n6Y6Q5hF9yknInVEjK4ylSxr/Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3S7xHh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3S7xHh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0ACC4CEED;
	Tue,  8 Jul 2025 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994177;
	bh=08M4hQHm12gPaSW7vst12y1ayxZ48Oo3hQuPdPHgZNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3S7xHh8j0TQzCANfPLrTgZX0hE9YHKEdVhxPc3KJXMtZEM8uJi5t4wNTNaFiEyoq
	 ke73XlalhcPjVSS3R0pOIGjTpOtOKvDBV3PQW0XUGVZPtJf7vuH/MvOb2uPyYkhsN2
	 JivhSscRudeDAmN2yWP0eBT07zyp0iRZSNpB7Bfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 152/160] i2c/designware: Fix an initialization issue
Date: Tue,  8 Jul 2025 18:23:09 +0200
Message-ID: <20250708162235.524391710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit 3d30048958e0d43425f6d4e76565e6249fa71050 upstream.

The i2c_dw_xfer_init() function requires msgs and msg_write_idx from the
dev context to be initialized.

amd_i2c_dw_xfer_quirk() inits msgs and msgs_num, but not msg_write_idx.

This could allow an out of bounds access (of msgs).

Initialize msg_write_idx before calling i2c_dw_xfer_init().

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250627143511.489570-1-michael.j.ruhl@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -298,6 +298,7 @@ static int amd_i2c_dw_xfer_quirk(struct
 
 	dev->msgs = msgs;
 	dev->msgs_num = num_msgs;
+	dev->msg_write_idx = 0;
 	i2c_dw_xfer_init(dev);
 	i2c_dw_disable_int(dev);
 


