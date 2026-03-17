Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF13F54C9;
	Tue, 17 Mar 2026 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766120; cv=none; b=qaP6/PEG1ih5LkLDbbl/oyK/8ZNdEpX7cYzBnR3SX5h2aKNr0ycBT2Q1kktMV50bjazdVFLPWFHmEIrgBXzhxC4AGszA7PZs7IhYPexDsh4A6IkIB7c9TnQVTIOVLNnuzpNS1+8hDBtE0Uzrfgw0yiUMeYkdA2wlGKR0KqYTk74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766120; c=relaxed/simple;
	bh=DlGDmUJoSe3rkInytGjNA2Q7jW0K+UiiuK2gfjQg9Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLHB/wFmXS2c7BMtSwnDpJyDRpAb4OvgW6XS4JnGranAEcGw2MQezM/YiKyiP9CmjgBEG5o5OwQq+vfoy9WPbXVvAgJ8z1aN+wUapLYTW+DOIU/xKTollybOvTazfzSJeIQV+NhbQzE4BuI/tMpxHMTV2MbObRBbqDgwpf+PIi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maTqaNv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maTqaNv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F45C4CEF7;
	Tue, 17 Mar 2026 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766120;
	bh=DlGDmUJoSe3rkInytGjNA2Q7jW0K+UiiuK2gfjQg9Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maTqaNv+sFhxszYmQOWaOQvf98hiPJhEUpaOG62QBxmn/CWw7xyJRhywZNX6GLv2G
	 FkVrl6Fj36w5Z2wVKzI/osWeeHech09fy6l/E7saH2FrR7JdQK6Vargs+Ez8SiWWww
	 ilK0L+4dbPb5hyd78FLExFIX2u6AyNahvyN4fSt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hristo Venev <hristo@venev.name>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.19 175/378] ceph: do not skip the first folio of the next object in writeback
Date: Tue, 17 Mar 2026 17:32:12 +0100
Message-ID: <20260317163013.446385623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hristo Venev <hristo@venev.name>

commit 081a0b78ef30f5746cda3e92e28b4d4ae92901d1 upstream.

When `ceph_process_folio_batch` encounters a folio past the end of the
current object, it should leave it in the batch so that it is picked up
in the next iteration.

Removing the folio from the batch means that it does not get written
back and remains dirty instead. This makes `fsync()` silently skip some
of the data, delays capability release, and breaks coherence with
`O_DIRECT`.

The link below contains instructions for reproducing the bug.

Cc: stable@vger.kernel.org
Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Link: https://tracker.ceph.com/issues/75156
Signed-off-by: Hristo Venev <hristo@venev.name>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1330,7 +1330,6 @@ int ceph_process_folio_batch(struct addr
 		} else if (rc == -E2BIG) {
 			rc = 0;
 			folio_unlock(folio);
-			ceph_wbc->fbatch.folios[i] = NULL;
 			break;
 		}
 


