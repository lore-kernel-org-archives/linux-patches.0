Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AF21E7C3A;
	Thu, 13 Feb 2025 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458499; cv=none; b=aMFi/MbQcKSlDREfhoIP84O/s7mow6VQ3t0NgHzhxDasf+WIlxSsgY48yHKYOztvVoISD7EOpvggeHvhqPxZAdDLIbxoQkzlkok1LW4QeD601MwrQWJ1KsdI6Uk47oGmWsfTrPz2HwI0N5oddP99tz0N//ANKAONAEHwuRFYiWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458499; c=relaxed/simple;
	bh=NQrTozOOW5zPVGadbxc0ES6uJqPd0PB+cWZoa0csJoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYGmIkX/aFhWszYrZNRR6+Qdo+lbIEN/qmSFfFKwQILCogMqg0gpglWDpFxtjF8pI9tRneQ4xjFR9huNRCh15vIIEyGeb7FvKveniUQrh9nJwCtBSxN8HXxe0EPSjOVJdlwZeWc04xxcTkwO7xZUJm8guQNwbUzKsGdExelWdx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAh9XAs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAh9XAs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE94C4CEE5;
	Thu, 13 Feb 2025 14:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458498;
	bh=NQrTozOOW5zPVGadbxc0ES6uJqPd0PB+cWZoa0csJoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAh9XAs8ESY49n0JfH/ZQqW8LF7p8ZZXZ+8CpMqEU3geNYItGfgcxqb9otxTbSOXm
	 M3lt0AARInhs0dyRiiEHgc72Q1M9XjLBp/8b9eYfROxyJApYBnMTff9VGXQCI0+KPa
	 gWJAdY6wa847cVgNdp74xBsK9o4qzHebm0Tr+5QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 418/422] fs: prepend statmount.mnt_opts string with security_sb_mnt_opts()
Date: Thu, 13 Feb 2025 15:29:27 +0100
Message-ID: <20250213142452.695896391@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 056d33137bf9364456ee70aa265ccbb948daee49 upstream.

Currently these mount options aren't accessible via statmount().

The read handler for /proc/#/mountinfo calls security_sb_show_options()
to emit the security options after emitting superblock flag options, but
before calling sb->s_op->show_options.

Have statmount_mnt_opts() call security_sb_show_options() before
calling ->show_options.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20241115-statmount-v2-2-cd29aeff9cbb@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5eb987105357 ("fs: fix adding security options to statmount.mnt_opt")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5025,6 +5025,10 @@ static int statmount_mnt_opts(struct kst
 	if (sb->s_op->show_options) {
 		size_t start = seq->count;
 
+		err = security_sb_show_options(seq, sb);
+		if (err)
+			return err;
+
 		err = sb->s_op->show_options(seq, mnt->mnt_root);
 		if (err)
 			return err;


