Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1622C1E3DF9;
	Tue,  3 Dec 2024 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242289; cv=none; b=XajkcEhvFyQ8p7vDu4p8IKUod/bSbXodwmBuMovtOrdwNas11TfdG7G42oKiylvJGi/hP2Cy0eEyyg1PsTIrvTBi5j2QhkPyxJbp0NIt+bbejMihy1aUs3UUzGNhbxFVuzFYxM1Ne0OZk4T3kx5xcTDn1p6qaIV+ax2QeFIwVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242289; c=relaxed/simple;
	bh=VhOL3uUxkGJZx4TC2Kg6173cHoozm7UNZWT7d7WbnjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvwhL/YY6u/5xl8nzMzL6OaLyxEVj6ksXqqCjwyw4XTftnMpXBmthtn0AwzVhweGCrXvjseA883WUcVlK8ZYSvqcGpcgjDfGz/fXg4eEgPMJ7Wmy78xgvNxQ/oodQTptEXYB9yky0gCf/iD/xr0b2Tos/OGP+YdcsZGfh4/2N6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyTrcEdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyTrcEdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0D8C4CECF;
	Tue,  3 Dec 2024 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242288;
	bh=VhOL3uUxkGJZx4TC2Kg6173cHoozm7UNZWT7d7WbnjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyTrcEdOerbjd4tBDty9m2SuoirfziBdN7ElTGyf+7UTCc2EfvSUEMvncJRztf4CX
	 oWpS2DwO5q8qhx75Gf807oiw5+vOHGC0p6eGQt6sKe24l04bz9JmkZO5wLNebz83++
	 +Dj2t+JkV3y/3W7ZMQtuz8NQVEPljnX3OlqcUsOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Lin Feng <linf@wangsu.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.12 663/826] tty: ldsic: fix tty_ldisc_autoload sysctls proc_handler
Date: Tue,  3 Dec 2024 15:46:30 +0100
Message-ID: <20241203144809.617878204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

commit 635a9fca54f4f4148be1ae1c7c6bd37af80f5773 upstream.

Commit 7c0cca7c847e ("tty: ldisc: add sysctl to prevent autoloading of
ldiscs") introduces the tty_ldisc_autoload sysctl with the wrong
proc_handler. .extra1 and .extra2 parameters are set to avoid other values
thant SYSCTL_ZERO or SYSCTL_ONE to be set but proc_dointvec do not uses
them.

This commit fixes this by using proc_dointvec_minmax instead of
proc_dointvec.

Fixes: 7c0cca7c847e ("tty: ldisc: add sysctl to prevent autoloading of ldiscs")
Cc: stable <stable@kernel.org>
Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Reviewed-by: Lin Feng <linf@wangsu.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20241112131357.49582-4-nicolas.bouchinet@clip-os.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3631,7 +3631,7 @@ static struct ctl_table tty_table[] = {
 		.data		= &tty_ldisc_autoload,
 		.maxlen		= sizeof(tty_ldisc_autoload),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},


