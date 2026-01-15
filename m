Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E93BF303;
	Thu, 15 Jan 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496796; cv=none; b=nEb/kJPjZCELULVjgWuGodaUNJ87e2qrd7iZdSGEhdel8EOERXBvfFLEoyab04zbtJf/JOuROFQ+HUN2a0uJUpX2Trnul9wdOMYyD+44o120Aq73qwOU1Sk99Q3EC/yXqYkdHfYN4tfRvhWxzjQBTqXVdqf16pDJK/+1rdyRzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496796; c=relaxed/simple;
	bh=6JaJkqqQmLaNHVGQ+X/RftHv5aEkrHG9yY3EerSf+Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/tIYYJ7ig5linfm9vxNEnC/AJmojqedhCuQFH8U/qygeepSVr6Wfjv5dmd6JLW+diKYWB4pRJaxvidMJOQ03b2tP56xBna/bffU5ePUjiXof1xtDEVec3iLByhjBoBQDuXC+PgKgZhkMbofekdzRNg4hjs2fpDw86hkuFazmbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eWF1JrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eWF1JrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CBCC116D0;
	Thu, 15 Jan 2026 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496796;
	bh=6JaJkqqQmLaNHVGQ+X/RftHv5aEkrHG9yY3EerSf+Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eWF1JrQM+lQJTCArFJX9C8j2dAlJFu8Zj034TUiiHnl019EPVhFMWr0EiuOeCPFz
	 NJZ1whC1OaCQtIA7mSnn/LtO2YbRmmYaMKM57QXVVN8ODsabTEUK4dkw1PMC0fIIB1
	 xTVTk3cRIXk5WSOln8Bs06CBy5QyFVdbUQZquCP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 19/88] libceph: reset sparse-read state in osd_fault()
Date: Thu, 15 Jan 2026 17:48:02 +0100
Message-ID: <20260115164147.011602456@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

commit 11194b416ef95012c2cfe5f546d71af07b639e93 upstream.

When a fault occurs, the connection is abandoned, reestablished, and any
pending operations are retried. The OSD client tracks the progress of a
sparse-read reply using a separate state machine, largely independent of
the messenger's state.

If a connection is lost mid-payload or the sparse-read state machine
returns an error, the sparse-read state is not reset. The OSD client
will then interpret the beginning of a new reply as the continuation of
the old one. If this makes the sparse-read machinery enter a failure
state, it may never recover, producing loops like:

  libceph:  [0] got 0 extents
  libceph: data len 142248331 != extent len 0
  libceph: osd0 (1)...:6801 socket error on read
  libceph: data len 142248331 != extent len 0
  libceph: osd0 (1)...:6801 socket error on read

Therefore, reset the sparse-read state in osd_fault(), ensuring retries
start from a clean state.

Cc: stable@vger.kernel.org
Fixes: f628d7999727 ("libceph: add sparse read support to OSD client")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4306,6 +4306,9 @@ static void osd_fault(struct ceph_connec
 		goto out_unlock;
 	}
 
+	osd->o_sparse_op_idx = -1;
+	ceph_init_sparse_read(&osd->o_sparse_read);
+
 	if (!reopen_osd(osd))
 		kick_osd_requests(osd);
 	maybe_request_map(osdc);


