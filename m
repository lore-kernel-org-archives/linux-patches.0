Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C3C569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03166C433D2;
	Sun, 28 May 2023 19:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302012;
	bh=DaX/Qa0qZgwCTbDV1LbY73oGU0GtA/gpfwSAP3ajF08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYXLSLNbOGzzP3KwliiZOdHQpf234LoKGclBEpwhCXWgy/10DKBYLR/IGfb85Dbuz
	 a+0m9OSgutGRVNoU8+FKIksdiijIoDsSZlVnORpDXufsAIhdfmEz4SsuxCNXxtFUXy
	 axdUl4VzjxYJ5cINyEjaIJIaV5k1EMtqg/Sv4afs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.4 098/161] statfs: enforce statfs[64] structure initialization
Date: Sun, 28 May 2023 20:10:22 +0100
Message-Id: <20230528190840.234530040@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit ed40866ec7d328b3dfb70db7e2011640a16202c3 upstream.

s390's struct statfs and struct statfs64 contain padding, which
field-by-field copying does not set. Initialize the respective structs
with zeros before filling them and copying them to userspace, like it's
already done for the compat versions of these structs.

Found by KMSAN.

[agordeev@linux.ibm.com: fixed typo in patch description]
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/20230504144021.808932-2-iii@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/statfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -128,6 +128,7 @@ static int do_statfs_native(struct kstat
 	if (sizeof(buf) == sizeof(*st))
 		memcpy(&buf, st, sizeof(*st));
 	else {
+		memset(&buf, 0, sizeof(buf));
 		if (sizeof buf.f_blocks == 4) {
 			if ((st->f_blocks | st->f_bfree | st->f_bavail |
 			     st->f_bsize | st->f_frsize) &
@@ -156,7 +157,6 @@ static int do_statfs_native(struct kstat
 		buf.f_namelen = st->f_namelen;
 		buf.f_frsize = st->f_frsize;
 		buf.f_flags = st->f_flags;
-		memset(buf.f_spare, 0, sizeof(buf.f_spare));
 	}
 	if (copy_to_user(p, &buf, sizeof(buf)))
 		return -EFAULT;
@@ -169,6 +169,7 @@ static int do_statfs64(struct kstatfs *s
 	if (sizeof(buf) == sizeof(*st))
 		memcpy(&buf, st, sizeof(*st));
 	else {
+		memset(&buf, 0, sizeof(buf));
 		buf.f_type = st->f_type;
 		buf.f_bsize = st->f_bsize;
 		buf.f_blocks = st->f_blocks;
@@ -180,7 +181,6 @@ static int do_statfs64(struct kstatfs *s
 		buf.f_namelen = st->f_namelen;
 		buf.f_frsize = st->f_frsize;
 		buf.f_flags = st->f_flags;
-		memset(buf.f_spare, 0, sizeof(buf.f_spare));
 	}
 	if (copy_to_user(p, &buf, sizeof(buf)))
 		return -EFAULT;


