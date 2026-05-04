Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319303A7F4C;
	Mon,  4 May 2026 14:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903995; cv=none; b=EWE0QioFyktC26oX2LKkVjt34tBCVAUGLA0NovppyDIZHOZhXzjIcfRmk9U7XdIJgQ/ahau18TnEcVn4HcfwaZMirMdIsorYsQV1e/CzKUk4p+eep96uJfkcihnuhHSe6wZxvkGWkVgcgqjznmta+h/JuQbCqxWC9R8ZavEcgMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903995; c=relaxed/simple;
	bh=3swrdCRQRweRXIWDZzRI9mo6FhWfmgpAoaFLVLKSVhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2Q8EX6WYlclGz4V6G3/32MkrQKvLf+h0U2cZ8zKjEH+99WHTYuN+FggI/CLxtHqBVeXxTqhNgoUlskAW8w15EdRm1s200ZL2DsBmuLAeDafOnPvBzx8DoKWu6nmIwO8EUmrtfFgRJQUSywxRbtMyP6eoqyuesObjjBCJzfFNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSkhk1aF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSkhk1aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD793C2BCB8;
	Mon,  4 May 2026 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903995;
	bh=3swrdCRQRweRXIWDZzRI9mo6FhWfmgpAoaFLVLKSVhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSkhk1aFBfO3ldIK/WVBn88eRaw5duvQBx4bPOO/IuK1+HcUzOnztFMjMGEXBQBz1
	 bMBeGN0WyoE9qjpMjyhVcFlw+accKffScUYGBpDhNtQ8RK2eE1mtbSumnslQLC0Iwp
	 zCzRG3l8nSc8XFcXKDWP8V0yPAc8GRB4TKfoCo/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <listout@listout.xyz>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 142/275] ASoC: Intel: avs: replace strcmp with sysfs_streq
Date: Mon,  4 May 2026 15:51:22 +0200
Message-ID: <20260504135148.176043679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

commit 45e9066f3a487e9e26b842644364d045af054775 upstream.

allmodconfig failes to build with GCC 16 with the following build error

sound/soc/intel/avs/path.c:137:38: error: ‘strcmp’ reading 1 or more bytes from a region of size 0 [-Werror=stringop-overread]
  137 |         return id->id == id2->id && !strcmp(id->tplg_name, id2->tplg_name);
      |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ‘avs_condpaths_walk’: events 1-3
  137 |         return id->id == id2->id && !strcmp(id->tplg_name, id2->tplg_name);
      |                ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                  |   |
      |                                  |   (3) warning happens here
      |                                  (1) when the condition is evaluated to true
......
  155 |         if (id->id != path->template->owner->id ||
      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                 |
      |                                                 (2) when the condition is evaluated to false
  156 |             strcmp(id->tplg_name, path->template->owner->owner->name))
      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from sound/soc/intel/avs/path.h:14,
                 from sound/soc/intel/avs/path.c:15:
sound/soc/intel/avs/topology.h: In function ‘avs_condpaths_walk’:
sound/soc/intel/avs/topology.h:152:13: note: at offset 4 into source object ‘id’ of size 4
  152 |         u32 id;
      |             ^~

Using the sysfs_streq as an alternative to strcmp helps getting around
this build failure.
Please also refer
https://docs.kernel.org/core-api/kernel-api.html#c.__sysfs_match_string

Signed-off-by: Brahmajit Das <listout@listout.xyz>
Link: https://patch.msgid.link/20251221185531.6453-1-listout@listout.xyz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/avs/path.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -134,7 +134,7 @@ static struct avs_tplg_path *avs_condpat
 static bool avs_tplg_path_template_id_equal(struct avs_tplg_path_template_id *id,
 					    struct avs_tplg_path_template_id *id2)
 {
-	return id->id == id2->id && !strcmp(id->tplg_name, id2->tplg_name);
+	return id->id == id2->id && !sysfs_streq(id->tplg_name, id2->tplg_name);
 }
 
 static struct avs_path *avs_condpath_find_match(struct avs_dev *adev,


