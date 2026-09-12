Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71F4332610;
	Sat, 12 Sep 2026 07:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198969; cv=none; b=FhCnaZB0MWc1jvENs11S54is9Vl6GUfmYeYZjDgPUlKo+OszolDJxYeguKqNfqtp5hiTxrHBSwutZ5/PcoH9+/wqdh/8fj16WCqmsGUXGZIe4QeOoYCjySYSEiJmSmDmMeS90/97/Xm3P/4feDqTW0MWw+3zLWKDaZmZCyOTODI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198969; c=relaxed/simple;
	bh=B5sauVp68vJztLIxDEeTX7bQsL/cI6BrDrz6eEAXr6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ9gUfpIObskw4RFvtbwiJCWrc3KZo4FCV/l9LnT5c8ZmBUlQVkmQ0oKWKNAPI+z3PB/xBQUQUdGJ0ng2sNNWU+utToKCVTz96zPlK7PATn34f8Oa/kdbaABiwkt63pV/0XyuUK5+JqQpTqRIT9F2uQqp33DJf3DU3UAUBv4ZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WH+Op4f+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WH+Op4f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD7C1F000FF;
	Sat, 12 Sep 2026 07:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198968;
	bh=B2kuhdntnlOLtxlvqtsueF8YcGj3ugQZT+31SScTArU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WH+Op4f+Ewb8ibUh8BitZfprQIbWvuYM4TQi872pXu1QLj5rQ+nLcEVMalMCPRNub
	 cmj4u8NfEkERZvGYwsDUqmAwfjhd6mOy0gs3G2PgxkRpFJ3Tr6UCVOB/zq/VkcYmUD
	 LFlaDfebLqeMNLpQ/hE0BZ2n3p+PcWEZS/zG9jY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0488/1815] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 08:37:18 +0200
Message-ID: <20260912065700.347823941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



