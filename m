Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878CA350A05;
	Thu, 15 Jan 2026 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496477; cv=none; b=E7iJ5PIuLNNJUpYIQfkeuBNr2GX3FVYQOgXkEh0RcNMvY/qLHYs2yqaN95mc6ixwqBRmhq5gC31pgCg16saSol7xgGTZo9jDjfSD/P+k0n4frV6Di9l/ivrPsYRQUZF8Reud1MidZ33FS+ULVAjErgpbFuFu3f8XQkTamELFikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496477; c=relaxed/simple;
	bh=Jp6HLUCLsHSa1cvnd5UfFnERefSrxHcX6/WH4vvPCPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQU+VkBEiUGpVJF3OV7XJPbmsmQ69i85CEj4ZCFMCs5OwnmnHcy2XcA7f0im6Yjo6aal0uZqS9GMfD0XwqHQG0BMoMzJU4cFyEPPVEf2E6ixeCFuAaOEdhV6DWZiqIegJi+MaqNiZ9Pon+udcz6hvyFo+vzx1MQgXqfVbbmX4jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAM2czfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAM2czfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13144C16AAE;
	Thu, 15 Jan 2026 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496477;
	bh=Jp6HLUCLsHSa1cvnd5UfFnERefSrxHcX6/WH4vvPCPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAM2czfPbYhMz7tJD3jKbLKDeK3dr1NJUen0adZr73a4CSO/9BhUPBDd+zbEmx/+R
	 g1yxYSkJoFQdxFPUtmOkRHVdMN1ETpOJ18QbWVFAa/OyXSBmwSvO3KMf2VuFPQ7rzc
	 WWAggFUSv9ieQnDlUApr4eOg/9MfPUZ4OlWwVkLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 026/119] libceph: reset sparse-read state in osd_fault()
Date: Thu, 15 Jan 2026 17:47:21 +0100
Message-ID: <20260115164152.905596774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


