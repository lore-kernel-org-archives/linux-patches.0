Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275641DE2AE;
	Tue,  8 Oct 2024 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392756; cv=none; b=uTc3+pRqIoqIekVxw4SOZZEEz51qK8NIKvR3hxAvx9saEjAwrBwCZDTeMtI6Djw6gsGBNpXZXUiVTs1wfvEzYyX/1VkbVDIr2XhyTXhPLyDIfBzw2+ot9rdc0dYZAJc+Jyz/UWM0DyE6xWHBx0Yq0pDSaCavzz2MdhjpRdHcTWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392756; c=relaxed/simple;
	bh=TpAKeOQVKFjzC8dIEYmKlS8R5UEs9aqcygny6zA9gUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMW2CtIaBIzpc+TZ6erlL/CTHVU25MyvS4zex3opuoug08z+OL7piww4ubT46TwldSigoT6GfdvTOUqbjpJdDpO499gbHD2or3blpbh1rQWBtqGVR57tAIl6jI4YCQKBAKo9swpGnjvBA/OZdORUsUeXzwbXi/+hPWvbr7MmYec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOjI+lhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOjI+lhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97924C4CEC7;
	Tue,  8 Oct 2024 13:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392756;
	bh=TpAKeOQVKFjzC8dIEYmKlS8R5UEs9aqcygny6zA9gUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOjI+lhVVJq9AmM2Yuw0s+VmrxXoynhL40xe8tQH9UDJ5vTA7Yw4jy9su+KPEBLy3
	 bfDx9INSraLH4MWWEc0XrTQBpkJrqz7RKPmh83Miiq4ORCGoCsqAEkPViM+pHnNMn8
	 RSopUWp1WGq5+lSCESQAXFBBvtyt1oTCRrJXi/Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.11 508/558] ceph: fix cap ref leak via netfs init_request
Date: Tue,  8 Oct 2024 14:08:58 +0200
Message-ID: <20241008115722.221244735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Donnelly <pdonnell@redhat.com>

commit ccda9910d8490f4fb067131598e4b2e986faa5a0 upstream.

Log recovered from a user's cluster:

    <7>[ 5413.970692] ceph:  get_cap_refs 00000000958c114b ret 1 got Fr
    <7>[ 5413.970695] ceph:  start_read 00000000958c114b, no cache cap
    ...
    <7>[ 5473.934609] ceph:   my wanted = Fr, used = Fr, dirty -
    <7>[ 5473.934616] ceph:  revocation: pAsLsXsFr -> pAsLsXs (revoking Fr)
    <7>[ 5473.934632] ceph:  __ceph_caps_issued 00000000958c114b cap 00000000f7784259 issued pAsLsXs
    <7>[ 5473.934638] ceph:  check_caps 10000000e68.fffffffffffffffe file_want - used Fr dirty - flushing - issued pAsLsXs revoking Fr retain pAsLsXsFsr  AUTHONLY NOINVAL FLUSH_FORCE

The MDS subsequently complains that the kernel client is late releasing
caps.

Approximately, a series of changes to this code by commits 49870056005c
("ceph: convert ceph_readpages to ceph_readahead"), 2de160417315
("netfs: Change ->init_request() to return an error code") and
a5c9dc445139 ("ceph: Make ceph_init_request() check caps on readahead")
resulted in subtle resource cleanup to be missed. The main culprit is
the change in error handling in 2de160417315 which meant that a failure
in init_request() would no longer cause cleanup to be called. That
would prevent the ceph_put_cap_refs() call which would cleanup the
leaked cap ref.

Cc: stable@vger.kernel.org
Fixes: a5c9dc445139 ("ceph: Make ceph_init_request() check caps on readahead")
Link: https://tracker.ceph.com/issues/67008
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -473,8 +473,11 @@ static int ceph_init_request(struct netf
 	rreq->netfs_priv = priv;
 
 out:
-	if (ret < 0)
+	if (ret < 0) {
+		if (got)
+			ceph_put_cap_refs(ceph_inode(inode), got);
 		kfree(priv);
+	}
 
 	return ret;
 }


