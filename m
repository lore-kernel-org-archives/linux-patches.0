Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C4D34F48F;
	Sat, 30 May 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160180; cv=none; b=A19XLY0Bc4Ju04YdPwb+cXObzAX4UeXV/qYVJxgLqoSthTi67Nh1xDewWWh7WTiOIxU8HaahmoKx8RUXGcaPu+VgZ1XYkyW6eziIdED4kmeEk3qk/XfEbkAcP1OYZRaAYF33D1ZuwLcGJil4EtICZx4kN8WN6m5D5iDlHFhO3K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160180; c=relaxed/simple;
	bh=TEh4q/tVZEjl6I3LJxvrkNW9yKMp0XG+fFYNGOT4INA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI4wP3JfTgsVjBYyEx/wg2L5eojFDb2Hu40ZJZWJ0D8eLQwDJL2RpYKlSswK3mZOnex52uy+UHJRldNjMYvm0oCl6j0Uf7zk64JgeTwrnqKdXd4s3vtr/BCJrEP3pd2ixhiEUpvSg6OQi7kc3Vmyb7BOGBZqSM/Hk7amiqbcpkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=015gsme7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="015gsme7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A0E1F00893;
	Sat, 30 May 2026 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160179;
	bh=iEn4h/ZpJDD/qa6Ve/q/yaraw/8MMgBerCYfjlla/Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=015gsme7qYpTlJQm2t+VRPiSrgvuYeHddQ+Akkd8qktKG1Bffj7zRpZ+s8emO1pBI
	 yCFKqa6PcRbMaOk7qhU6GJYu7DbhDow/hyHhfHvUBBFx4QSOXfG3sRIP12mvCpPiEe
	 d79+15rbZS3+rE0cpPpmfvA+f1sosw3rGi+1ertE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 266/969] ntfs3: fix integer overflow in run_unpack() volume boundary check
Date: Sat, 30 May 2026 17:56:30 +0200
Message-ID: <20260530160307.819998496@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Gaertner <tob.gaertner@me.com>

commit 984a415f019536ea2d24de9010744e5302a9a948 upstream.

The volume boundary check `lcn + len > sbi->used.bitmap.nbits` uses raw
addition which can wrap around for large lcn and len values, bypassing
the validation.  Use check_add_overflow() as is already done for the
adjacent prev_lcn + dlcn and vcn64 + len checks added by commit
3ac37e100385 ("ntfs3: Fix integer overflow in run_unpack()").

Found by fuzzing with a source-patched harness (LibAFL + QEMU).

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Gaertner <tob.gaertner@me.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1018,9 +1018,15 @@ int run_unpack(struct runs_tree *run, st
 			return -EOPNOTSUPP;
 		}
 #endif
-		if (lcn != SPARSE_LCN64 && lcn + len > sbi->used.bitmap.nbits) {
-			/* LCN range is out of volume. */
-			return -EINVAL;
+		if (lcn != SPARSE_LCN64) {
+			u64 lcn_end;
+
+			if (check_add_overflow(lcn, len, &lcn_end))
+				return -EINVAL;
+			if (lcn_end > sbi->used.bitmap.nbits) {
+				/* LCN range is out of volume. */
+				return -EINVAL;
+			}
 		}
 
 		if (!run)


