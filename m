Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC211202C46;
	Sun,  7 Jun 2026 10:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827906; cv=none; b=H0Jtk4TOeF/snWzxn2k62CUi5wmZMIEn6qpW+AeODBoAuq6oSNR3RlJdCjEHrkzx07qMeh3TvQ8BzhWD8nIRPL9FaR1Np4maTQCoSn+dyCO/3BlVgF44KyT48N/z14NnQoSum6GGJH8tJigE0S93QmzOifQedeBB26+/kI90Crk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827906; c=relaxed/simple;
	bh=E2wsE+oqm+q9J/NE/Kqmiqr7xrzYaWI6OnB7okd2noM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkfzVItzF8ljxkEVya3vUmqjZMgE3+gYt8RWT0Ghq8buzXYzD7h7dDAE5PUzWo/gcx+zjdQTvjkkMweHDycO69XKT1RsEHAZxpOauppkfBw0wmv7n8MJrKER/gNJkCQiNuSjdPsjiPqYh3c+/MfKh0bCifHnZ2Ys1u6kMuW63Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoDNJiqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoDNJiqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9BC1F00893;
	Sun,  7 Jun 2026 10:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827905;
	bh=RZ9hjEK9Jm+suAX39ACgZMcoeDjnaBD9Zt6PtA7pr3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoDNJiqYSIw6udqIGDYiQT7kcKuM/ZpejrgWCwFw8i5++ZavTboPYDyb4s2fAAhrO
	 ICs90jTBEdapIR582jjDjGeK/c+m2l27AuADOnyQ6LP0pRRxQZCa3taEUbCfjvAtCU
	 YZOGQhlabRNC+56WZkUTJtjPotF5KVucbK+1/j5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 7.0 136/332] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Sun,  7 Jun 2026 11:58:25 +0200
Message-ID: <20260607095733.090905377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 974820a59efde7c1a7e1260bcfe9bb81f833cc9f upstream.

If hpfs_map_dnode_bitmap fails, the code would call hpfs_brelse4 on
uninitialized quad buffer head, causing a crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hpfs/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -372,8 +372,8 @@ int hpfs_check_free_dnodes(struct super_
 				return 0;
 			}
 		}
+		hpfs_brelse4(&qbh);
 	}
-	hpfs_brelse4(&qbh);
 	i = 0;
 	if (hpfs_sb(s)->sb_c_bitmap != -1) {
 		bmp = hpfs_map_bitmap(s, b, &qbh, "chkdn1");


