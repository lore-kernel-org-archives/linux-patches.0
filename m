Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B35396B7D;
	Thu, 15 Jan 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496086; cv=none; b=moFT9DAu2TmipPqNGOf/Ug805LF45onJf8HAZ7ET26h79eU+tTUx+0DG3tu9Img2T70ims4ZUTeVgO5n5ifHx1qTtrU3RSkDXVAHMkC6zVNkQrSZpMZBaMHqT65EpXh7tegENMzPdQSlgmaXQd6Q3cSLx8N0IEHqRiY4ubdDW8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496086; c=relaxed/simple;
	bh=ATWq8hUwAnqBYkOJ5jxxnNTF2HE9xD6P3KwZsPrMtXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIvymxo3O8eL7JFWUye7zTjehaqWXn6GxWX84agnhfu9Rrnds/UcAHCGn1ApYQ+n3aUZeX0mX3bvKRG73evvKhBmtH9I9Df7Lv6Ybij+BKmWUl5kckNJtlioZSMBCxmNFF1rWyRrexz7g3sd7jEm+xq8CNNqm+L3vU1tq3liYOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR24ikuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR24ikuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60BAC116D0;
	Thu, 15 Jan 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496086;
	bh=ATWq8hUwAnqBYkOJ5jxxnNTF2HE9xD6P3KwZsPrMtXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR24ikuEi06wXaKwwfLb5wuwNrdw0gCN4ZFrYEgELKI89+DkFTAthTDsWqBWcJ3iO
	 xiLXmUpNwLrrcC1HTVJ8KEYNPJ4L1s4Dp9fvm5eBdmGe1gBfJWmGBQGf+CmeOL6xP6
	 T+Wal3MIEVYOp96wwABzOKBU7rsc+q0t3kTYtb1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 039/181] libceph: prevent potential out-of-bounds reads in handle_auth_done()
Date: Thu, 15 Jan 2026 17:46:16 +0100
Message-ID: <20260115164203.740212075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ziming zhang <ezrakiez@gmail.com>

commit 818156caffbf55cb4d368f9c3cac64e458fb49c9 upstream.

Perform an explicit bounds check on payload_len to avoid a possible
out-of-bounds access in the callout.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Signed-off-by: ziming zhang <ezrakiez@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2377,7 +2377,9 @@ static int process_auth_done(struct ceph
 
 	ceph_decode_64_safe(&p, end, global_id, bad);
 	ceph_decode_32_safe(&p, end, con->v2.con_mode, bad);
+
 	ceph_decode_32_safe(&p, end, payload_len, bad);
+	ceph_decode_need(&p, end, payload_len, bad);
 
 	dout("%s con %p global_id %llu con_mode %d payload_len %d\n",
 	     __func__, con, global_id, con->v2.con_mode, payload_len);


