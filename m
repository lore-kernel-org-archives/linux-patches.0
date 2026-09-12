Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE62B343893;
	Sat, 12 Sep 2026 12:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215656; cv=none; b=gK/6ca0DQKabI1TX9mMnUd9t0X4yBUHuShL3EY0fVnBUwmdAQ4UUIyZg18yCwJg2dnhMhF/OhlPmjU+QlmMfead0hrxM9G/6y2a8UwoS8KwDUEPmtCY18QTPIk0x5n1JkjCQYKjNxw9c3lysN9eeUOSRmB+kWHsrkKuFxUBQ40c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215656; c=relaxed/simple;
	bh=9hxJpeLsnGMf/ygWIbRXZ6LviIimhLMilDDm0zN+vbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCco3IDv/J7qT0gQWdXPDXXrgGss0/7cNNFSM/lo342yoxfl/aClvVXLs12wx4VqoR7/R/EaH8XMHGKQclnzP+iA1mjUQ5kkeHGIr+8hz8XvdUSZl+HDA014OUQHdOADacP7pyIzotFLR0uBJHOOzGg8oPpd1zUjiGFn+gVZYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4EKbdnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4EKbdnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6351F000FF;
	Sat, 12 Sep 2026 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215654;
	bh=a3mW6aaqLrrRaIX7RuOp8qRCzDdU+v2lfkVPVqkkSb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4EKbdnZqQbHvYcsVSJY6rDjyKpzDo8pdD6nn72T8jE3K0u2Lud1J/t4T74eSyCE+
	 dQuiRoCgvKEuFMufgU21KeJg+Szy3EubGR7Q3SazJbNqZSfYwHndE3HPbI/JhRxAqI
	 2kJgajLsIJrHAQCV5VVmhx3ilBOSFxiYubSlCe/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0577/1376] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 08:50:03 +0200
Message-ID: <20260912065620.390439149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit d23eb7380d1594cda31a5dc8487dd2a5c8def8c7 ]

udf_symlink_filler() can enter udf_pc_to_char() with a partial pathComponent header.

Validate that enough input remains for a complete pathComponent header
before accessing it. Reject malformed symlink data that would otherwise
make udf_pc_to_char() perform an out-of-bounds read.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Link: https://patch.msgid.link/20260717104722.41446-1-david.lee@trailofbits.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index fe03745d09b18..a05d1888a2bab 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -36,6 +36,8 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 	/* Reserve one byte for terminating \0 */
 	tolen--;
 	while (elen < fromlen) {
+		if (fromlen - elen < sizeof(struct pathComponent))
+			return -EIO;
 		pc = (struct pathComponent *)(from + elen);
 		elen += sizeof(struct pathComponent);
 		switch (pc->componentType) {
-- 
2.53.0



