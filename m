Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273F114D2BD;
	Fri,  6 Dec 2024 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498218; cv=none; b=glpHeOPsLQ5HG9G5ZfwlooFaOaOwyBv4SlkJzouRD92vE4IoIP5PKLuC0nVTaP3qwMw+rcUZgvt3TJkLydoCU+6NWGwv+fYcs6SptKolm5ePxMJ4WHjN2IxcG51v14d91jVU92wdMpLEB8oyxrzEtulaPC/8hX3tghJ2iP1EKaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498218; c=relaxed/simple;
	bh=Go5x1u4dbGhXjaKyuhKmOzDKL4OSErUUvUPBaYGhkls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn8k6+4nrB0KrvcNziSb+j5cm8U6CMbBr1oZPSRRV2a58GqF7v1kxx4J0/r+o5RRhuP4LZzwGBeuV5X+rldqZhhjCUhzvz5sxiOeXkc+kMasKRITISBpWjhZRBXhkBi5Tc16oEa5TpmSic4TweluDzbk2o9vapne/6huuScbIPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsoLGcj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsoLGcj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B1BC4CED1;
	Fri,  6 Dec 2024 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498218;
	bh=Go5x1u4dbGhXjaKyuhKmOzDKL4OSErUUvUPBaYGhkls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsoLGcj7Lf1pUCv31IkdYnNNK2WBhVJDAqVBJm6FqzvUFUIhJnA4VQH5Zc2wI7Lm/
	 7gBrgKVXdpTHibU0g37tbQOU7GzuJFz2wHlWlyQDg/APCQc2YklOAEjxICnOGlJRRW
	 lUgkXSm2NraqpD6KhmFrEl4HKBPGT2wsgFUtNJq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Lin Feng <linf@wangsu.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 488/676] tty: ldsic: fix tty_ldisc_autoload sysctls proc_handler
Date: Fri,  6 Dec 2024 15:35:07 +0100
Message-ID: <20241206143712.422854005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3607,7 +3607,7 @@ static struct ctl_table tty_table[] = {
 		.data		= &tty_ldisc_autoload,
 		.maxlen		= sizeof(tty_ldisc_autoload),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},


