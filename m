Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58568471257;
	Tue, 21 Jul 2026 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657469; cv=none; b=RG8j9numD4m+JJBO3lNEbLDLoSK80TD2QkRc4EnMU4VIYqN3MWEviNbZO5SA9IhHqhykkQQq3lgW8QtGUb57V3m8oD+rgF9PcXokbzjlMxZmlnnbZ25HHmXImp+VGj6ysJtCSIK+v90GSI8ouVpurSDlP7O8hqB/uVprVEzZygU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657469; c=relaxed/simple;
	bh=VqKw6R+H+XMo/LH0DQ0N6IRIR0nUGK5HqRQ3ZDfu0cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDh7hUL22vG4N2Oa8haZa/kuNKf5fvGx+pGNvVJrANbHUEiN20g0OyJRgx2jtF54MSm3R4BUdc4PaUoWILtncd4lSku5z6vebZ1BPZAdpn7GbU0/oEMf9c0f72w/ie1O1+6hcmAIKjqHL/+L87SUAKajC/SG5ingv48gWDORPuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqImbr1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqImbr1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED5E1F000E9;
	Tue, 21 Jul 2026 18:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657468;
	bh=xmKG7YHkjeKMJ4zv0SQ52qoZmF4xDukGLl0LJMFMmPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqImbr1wDl3gOmCSAO9dYMRX/F01ui/IoPQbk+1gePyTediPPeEmJi7TOwgUHjwbV
	 iwlsrS95If5cP5d11etT4GqE98XJ1cZI0INow3BjVagAB9qA+WRCdpMk8CZEvM0Rhm
	 W9auYrs2CzkJ6ILauxfUJoJAYX4Wq1m5gyrrh8Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0775/1611] perf dso: Fix heap overflow in dso__get_filename() on decompressed path
Date: Tue, 21 Jul 2026 17:14:51 +0200
Message-ID: <20260721152532.818413853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f973e52a99776fcc473488984828d1fce56d5382 ]

dso__get_filename() allocates name with malloc(PATH_MAX), but the
dso__filename_with_chroot() path replaces name with an asprintf'd
exact-size string (e.g. 8 bytes for "/a/b.ko").  When the DSO needs
decompression, dso__decompress_kmodule_path() writes the temp path
("/tmp/perf-kmod-XXXXXX", 22 bytes) into newpath, and strcpy(name,
newpath) overflows the smaller allocation.

Replace the strcpy with strdup(newpath) + free(name) so the buffer
is always correctly sized for its content.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 1d6b3c9ba756a513 ("perf tools: Decompress kernel module when reading DSO data")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 1205224e110375..cfbad2d0496e89 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -605,8 +605,15 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
 
 		/* empty pathname means file wasn't actually compressed */
 		if (newpath[0] != '\0') {
+			char *tmp = strdup(newpath);
+
+			if (!tmp) {
+				unlink(newpath);
+				goto out;
+			}
+			free(name);
+			name = tmp;
 			*decomp = true;
-			strcpy(name, newpath);
 		}
 	}
 	return name;
-- 
2.53.0



