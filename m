Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011AB1EF36C;
	Wed, 17 Sep 2025 12:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112872; cv=none; b=MHjQyXjGZ6K3VaB02IUs5W8H4pO2OHMw7+hBoU8x6LOpm6JsJy0pepa/5t5igVOltT6dcxR9DDca7sd9IaQYIUiNbH5RQ3n3rkLb36Hq4eMGqVqOyS1j1wL/gU0Dt/PQGq+NxoCjYAvnWWPGw80DfCTNSvlocvvssypzcIn2C2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112872; c=relaxed/simple;
	bh=5lvYwNdL/aNzA+RFoEDMJafT0LZTTRZf3WsrMX9Uxew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lalQpcazhK5MYMPI/ktoKJBEoMvNN/Sey6kfbyfAbCKy9zQuMsU0Yie7o/aZd0k1ruBIpb3FXsp/uRlC7z7xHnaiAmARgOcQjgASuljed5Vjxr8XdMjoT3EpbcSizn6e93VpA8ezDvOGctMiQ5QPsYvI4FwiUag29svMWfLElaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upf6zlow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upf6zlow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E352C4CEF0;
	Wed, 17 Sep 2025 12:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112871;
	bh=5lvYwNdL/aNzA+RFoEDMJafT0LZTTRZf3WsrMX9Uxew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upf6zlowm6iYm0+EBRokzDGqV9X3ELx7sq8RD+XgKYdQbnOrtMQSm85qoy3bPFhHh
	 Jcjtqyth5AEFljpr8SMAHXLKx6YsecEfvkBxjlbeynYEVSWrmjJ62RWSAeAEsgPBrt
	 6GmL8Xz5Sdn3PU55JkvSGNyeHKh6S4NdF0YszCkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.16 100/189] libceph: fix invalid accesses to ceph_connection_v1_info
Date: Wed, 17 Sep 2025 14:33:30 +0200
Message-ID: <20250917123354.303472871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit cdbc9836c7afadad68f374791738f118263c5371 upstream.

There is a place where generic code in messenger.c is reading and
another place where it is writing to con->v1 union member without
checking that the union member is active (i.e. msgr1 is in use).

On 64-bit systems, con->v1.auth_retry overlaps with con->v2.out_iter,
so such a read is almost guaranteed to return a bogus value instead of
0 when msgr2 is in use.  This ends up being fairly benign because the
side effect is just the invalidation of the authorizer and successive
fetching of new tickets.

con->v1.connect_seq overlaps with con->v2.conn_bufs and the fact that
it's being written to can cause more serious consequences, but luckily
it's not something that happens often.

Cc: stable@vger.kernel.org
Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1524,7 +1524,7 @@ static void con_fault_finish(struct ceph
 	 * in case we faulted due to authentication, invalidate our
 	 * current tickets so that we can get new ones.
 	 */
-	if (con->v1.auth_retry) {
+	if (!ceph_msgr2(from_msgr(con->msgr)) && con->v1.auth_retry) {
 		dout("auth_retry %d, invalidating\n", con->v1.auth_retry);
 		if (con->ops->invalidate_authorizer)
 			con->ops->invalidate_authorizer(con);
@@ -1714,9 +1714,10 @@ static void clear_standby(struct ceph_co
 {
 	/* come back from STANDBY? */
 	if (con->state == CEPH_CON_S_STANDBY) {
-		dout("clear_standby %p and ++connect_seq\n", con);
+		dout("clear_standby %p\n", con);
 		con->state = CEPH_CON_S_PREOPEN;
-		con->v1.connect_seq++;
+		if (!ceph_msgr2(from_msgr(con->msgr)))
+			con->v1.connect_seq++;
 		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_WRITE_PENDING));
 		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_KEEPALIVE_PENDING));
 	}


